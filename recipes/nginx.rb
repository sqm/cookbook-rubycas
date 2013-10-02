#
# Cookbook Name:: rubycas-server
# Recipe:: nginx
#

include_recipe 'nginx::source'

ssl_cert_key = node[:rubycas][:ssl][:ssl_key]
ssl_cert = node[:rubycas][:ssl][:ssl_cert]
https = node[:rubycas][:https]
ssl_req = node[:rubycas][:ssl][:ssl_req]

# Search databag/item specified by node attributes
ssl_config = data_bag_item(node[:rubycas][:ssl][:databag], node[:rubycas][:ssl][:databag_item])

# Create ssl cert and key files if we found a certificate and key
if ssl_config["ssl_certificate"] && ssl_config["ssl_certificate_key"]
  file ssl_cert do
    owner 'root'
    group 'root'
    mode 077
    content ssl_config["ssl_certificate"]
  end

  file ssl_cert_key do
    owner 'root'
    group 'root'
    mode 077
    content ssl_config["ssl_certificate_key"]
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
    :app_name => node[:rubycas][:user],
    :default_server => node[:rubycas][:default_server],
    :https_boolean => node[:rubycas][:https],
    :server_name => node[:rubycas][:server_name],
    :ssl_cert => ssl_cert,
    :ssl_cert_key => ssl_cert_key
  )
end
