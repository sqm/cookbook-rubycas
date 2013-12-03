#
# Cookbook Name:: rubycas
# Recipe:: nginx
#

::Chef::Recipe.send(:include, Rubycas::Helper)

# Add in extra modules for load balancer support
node.default[:nginx][:source][:modules] << 'nginx::http_realip_module'

# Compile nginx so we get a recent version
include_recipe 'nginx::source'

# Search data bag/item specified by node attributes
ssl_config = search_for_ssl_config

force_ssl = ssl_config.ssl_certificate && ssl_config.ssl_certificate_key

# Create ssl cert and key files if we found a certificate and key
if force_ssl
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
    :force_ssl => force_ssl,
    :server_name => node[:rubycas][:server_name],
    :ssl_cert => ssl_config.cert_file_path,
    :ssl_cert_key => ssl_config.key_file_path,
    :is_load_balanced => node[:rubycas][:is_load_balanced],
    :load_balancer_ip => node[:rubycas][:load_balancer_ip]
  )
end
