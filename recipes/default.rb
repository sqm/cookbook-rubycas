#
# Cookbook Name:: rubycas-server
# Recipe:: default
#

# Install Ruby with RVM
include_recipe 'rvm::system_install'
rvm_environment node[:rubycas][:ruby_version]

# Add Database resources
include_recipe 'mysql::server'
include_recipe 'database::mysql'

# Enable secure password generation
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:rubycas][:database][:password] = secure_password

# Save the node data unless using Chef-Solo
ruby_block 'save node data' do
  block do
    node.save
  end
  not_if { Chef::Config[:solo] }
end

# Externalize MySQL Database conection info in a ruby hash
 mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password]
 }

# Create rubycas database
database node[:rubycas][:database][:database] do
  connection mysql_connection_info
  provider   Chef::Provider::Database::Mysql
  action     :create
end

# Create RubyCAS user with directory
user node[:rubycas][:user] do
  home     node[:rubycas][:dir]
  comment  'RubyCAS Application User'
  supports :manage_home => true
  shell    '/bin/bash'
end

# Create template for RubyCAS user to use correct Ruby
template "#{node[:rubycas][:dir]}/.bashrc" do
  source "bashrc.erb"
  mode   0644
  owner  node[:rubycas][:user]
  group  node[:rubycas][:user]
  variables(
    :ruby_bin => "#{node[:rvm][:root_path]}/environments/#{node[:rubycas][:ruby_version]}"
  )
end

# Clone RubyCAS application
git node[:rubycas][:app_directory] do
  action     :checkout
  user       node[:rubycas][:user]
  group      node[:rubycas][:user]
  repository node[:rubycas][:git][:url]
  branch     node[:rubycas][:git][:branch]
end

# Create RubyCAS application configuration file
template "#{node[:rubycas][:app_directory]}/config/config.yml" do
  source 'config.yml.erb'
  owner  node[:rubycas][:user]
  group  node[:rubycas][:user]
  mode   0644
  variables(
    :application_server => node[:rubycas][:application_server],
    :port               => node[:rubycas][:port],
    :ssl_cert_path      => node[:rubycas][:ssl_cert],
    :ssl_cert_key_path  => node[:rubycas][:ssl_key],
    :uri_path           => node[:rubycas][:uri_path],
    :adapter            => node[:rubycas][:database][:adapter],
    :database_name      => node[:rubycas][:database][:database],
    :database_user      => node[:rubycas][:database][:user],
    :database_password  => node[:rubycas][:database][:password],
    :host               => node[:rubycas][:database][:host],
    :reconnect          => node[:rubycas][:database][:reconnect]
  )
end

# Write out Gemfile
template "#{node[:rubycas][:app_directory]}/Gemfile" do
  source 'Gemfile.erb'
  owner  node[:rubycas][:user]
  group  node[:rubycas][:user]
  mode   0644
  variables(
    :adapter_gem => node[:rubycas][:database][:adapter]
  )
end

# Install dependencies for RubyCAS application using rvm_shell LWRP
rvm_shell "bundle install rubycas" do
  ruby_string node[:rubycas][:ruby_version]
  cwd         node[:rubycas][:app_directory]
  user        node[:rubycas][:user]
  group       node[:rubycas][:group]
  code        %{RAILS_ENV=production bundle install --deployment}
  creates     "#{node[:rubycas][:app_directory]}/vendor/bundle"
end
