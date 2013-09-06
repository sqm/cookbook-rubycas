#
# Cookbook Name:: rubycas-server
# Recipe:: default
#

# Install Ruby with RVM
include_recipe 'rvm::system_install'
rvm_environment node[:rubycas][:ruby_version]

# setup database
include_recipe 'rubycas-server::database'

# Create RubyCAS user with directory
user node[:rubycas][:user] do
  home node[:rubycas][:dir]
  comment 'RubyCAS Application User'
  supports :manage_home => true
  shell '/bin/bash'
end

# Add RubyCAS user to RVM group
group "rvm" do
  action :modify
  members node[:rubycas][:user]
  append true
end

# Create template for RubyCAS user to use correct Ruby
template "#{node[:rubycas][:dir]}/.bashrc" do
  source "bashrc.erb"
  mode 0644
  owner node[:rubycas][:user]
  group node[:rubycas][:user]
  variables(
    :ruby_bin => "#{node[:rvm][:root_path]}/environments/#{node[:rubycas][:ruby_version]}"
  )
end

# Clone RubyCAS application
git node[:rubycas][:app_directory] do
  action :checkout
  user node[:rubycas][:user]
  group node[:rubycas][:user]
  repository node[:rubycas][:git][:url]
  revision node[:rubycas][:git][:branch]
end

[
  "#{node[:rubycas][:app_directory]}/tmp",
  "#{node[:rubycas][:app_directory]}/tmp/pids",
  "#{node[:rubycas][:app_directory]}/tmp/sockets"
].each do |dir|
  directory dir do
    owner node[:rubycas][:user]
    group node[:rubycas][:user]
    mode 0755
  end
end

authenticators = data_bag_item("rubycas", "authenticator")["authenticators"]

# Create RubyCAS application configuration file
template "#{node[:rubycas][:app_directory]}/config.yml" do
  source 'config.yml.erb'
  owner node[:rubycas][:user]
  group node[:rubycas][:user]
  mode 0644
  variables(
    :adapter => node[:rubycas][:database][:adapter],
    :application_server => node[:rubycas][:application_server],
    :authenticators => authenticators,
    :database_name => node[:rubycas][:database][:database],
    :database_password  => node[:rubycas][:database][:password],
    :database_user => node[:rubycas][:database][:user],
    :host => node[:rubycas][:database][:host],
    :port => node[:rubycas][:port],
    :reconnect => node[:rubycas][:database][:reconnect],
    :ssl_cert_key_path => node[:rubycas][:ssl_key],
    :ssl_cert_path => node[:rubycas][:ssl_cert],
    :uri_path => node[:rubycas][:uri_path]
  )
end

database_type = node[:rubycas][:database][:type]

# Create Gemfile
template "#{node[:rubycas][:app_directory]}/Gemfile" do
  source 'Gemfile.erb'
  owner node[:rubycas][:user]
  group node[:rubycas][:user]
  mode 0744
  variables(
    :adapter_gem => node[:rubycas][:database][:adapter_gem]
  )
end

# Install dependencies for RubyCAS application using rvm_shell LWRP
rvm_shell "bundle install rubycas" do
  ruby_string node[:rubycas][:ruby_version]
  cwd node[:rubycas][:app_directory]
  code %{bundle install}
end

# Install god in the rvm ruby
rvm_shell "gem install god" do
  ruby_string node[:rubycas][:ruby_version]
  cwd node[:rubycas][:app_directory]
  code %{gem install god --no-ri --no-rdoc}
end

# Drop off a god wrapper script
template '/usr/bin/god' do
  source 'god.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    :ruby_version => node[:rubycas][:ruby_version]
  )
end

# Use god to monitor unicorn process
include_recipe 'god::default'

template '/etc/god/conf.d/rubycas.god' do
  source 'rubycas.god.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
      :app_env => 'production',
      :app_root => node[:rubycas][:app_directory],
      :worker_count => 3,
      :user => node[:rubycas][:user],
      :watch_file => 'tmp/restart'
  )
end
