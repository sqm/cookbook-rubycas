#
# Cookbook Name:: rubycas-server
# Recipe:: nginx
#

ssl_cert_key = node[:rubycas][:ssl_key]
ssl_cert = node[:rubycas][:ssl_cert]
https = node[:rubycas][:https]
ssl_req = node[:rubycas][:ssl_req]

if node[:rubycas][:nginx]
  package 'nginx'
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

ssl_source = data_bag_item("rubycas", "nginx")

cookbook_file ssl_cert do
  cookbook 'sqm'
  source "#{ssl_source["ssl_certificate"]}.crt"
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end

cookbook_file ssl_cert_key do
  cookbook 'sqm'
  source "#{ssl_source["ssl_certificate"]}.key"
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, 'service[apache2]'
end

# Render nginx template
template '/etc/nginx/sites-available/rubycas' do
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

link '/etc/nginx/sites-enabled/rubycas' do
  to '/etc/nginx/sites-available/rubycas'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
end
