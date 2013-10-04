#
# Cookbook Name:: rubycas-server
# Recipe:: nginx
#

::Chef::Recipe.send(:include, Rubycas::Helper)

# Compile nginx so we get a recent version
include_recipe 'nginx::source'

# Search data bag/item specified by node attributes
ssl_config = search_for_ssl_config

use_ssl = ssl_config.ssl_certificate && ssl_config.ssl_certificate_key

# Create ssl cert and key files if we found a certificate and key
if use_ssl
  file ssl_config.cert_file_path do
    owner 'root'
    group 'root'
    mode 077
    content ssl_config.ssl_certificate
  end

  file ssl_config.key_file_path do
    owner 'root'
    group 'root'
    mode 077
    content ssl_config.ssl_certificate_key
  end
end

# Render nginx template
template '/etc/nginx/sites-enabled/rubycas' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode  0755
  notifies :restart, 'service[nginx]'
  variables(
    :app_home => node[:rubycas][:app_directory],
    :port => node[:rubycas][:port],
    :app_name => node[:rubycas][:user],
    :default_server => node[:rubycas][:default_server],
    :https_boolean => use_ssl,
    :server_name => node[:rubycas][:server_name],
    :ssl_cert => ssl_config.cert_file_path,
    :ssl_cert_key => ssl_config.key_file_path
  )
end
