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

execute 'create-ssl-key' do
  cwd '/etc/nginx'
  user 'root'
  group 'root'
  umask 0077
  command "openssl genrsa 2048 > #{ssl_cert_key}"
  not_if { !https || File.exists?(ssl_cert_key) }
end

execute 'create-ssl-cert' do
  cwd '/etc/nginx'
  user 'root'
  group 'root'
  umask 0077
  command "openssl req -subj \"#{ssl_req}\" -new -x509 -nodes -sha1 -days 3650 -key #{ssl_cert_key} > #{ssl_cert}"
  not_if { !https || File.exists?(ssl_cert) }
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

link '/etc/nginx/sitesi-enabled/default' do
  action :delete
end
