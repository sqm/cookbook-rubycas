#
# Cookbook Name:: rubycas
# Recipe:: server
#

::Chef::Recipe.send(:include, Rubycas::Helper)

# Grab values from data bag/item based on node attributes
authenticators = search_for_authenticators_config.authenticators

# Grab values for database from data bag using Rubycas::Helper
db_config = search_for_database_config

# Install database adapter gem along with development headers
# for database
db_config.required_client_recipes.each do |recipe|
  include_recipe recipe
end

# Install Ruby with RVM
include_recipe 'rvm::system_install'
rvm_environment node[:rubycas][:ruby_version]

service "rubycas-unicorn" do
  restart_command "touch #{node[:rubycas][:app_directory]}/tmp/restart.txt"
  supports :restart => true
end

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

# Create RubyCAS application configuration file
template "#{node[:rubycas][:app_directory]}/config.yml" do
  source 'config.yml.erb'
  owner node[:rubycas][:user]
  group node[:rubycas][:user]
  mode 0644
  variables(
    :database_adapter => db_config.adapter,
    :application_server => node[:rubycas][:application_server],
    :authenticators => authenticators,
    :database_name => db_config.name,
    :database_password  => db_config.password,
    :database_user => db_config.username,
    :database_host => db_config.host,
    :database_port => db_config.port,
    :reconnect => node[:rubycas][:database][:reconnect],
    :ssl_cert_key_path => node[:rubycas][:ssl_key],
    :ssl_cert_path => node[:rubycas][:ssl_cert],
    :uri_path => node[:rubycas][:uri_path]
  )
  notifies :restart, 'service[rubycas-unicorn]'
end

# Create Gemfile
template "#{node[:rubycas][:app_directory]}/Gemfile" do
  source 'Gemfile.erb'
  owner node[:rubycas][:user]
  group node[:rubycas][:user]
  mode 0744
  variables(
    :adapter_gem => db_config.database_adapter_gem
  )
  notifies :restart, 'service[rubycas-unicorn]'
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
      :watch_file => 'tmp/restart.txt'
  )
  notifies :restart, 'service[god]'
end
