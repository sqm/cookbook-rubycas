#
# Cookbook Name:: rubycas
# Recipe:: nginx
#

::Chef::Recipe.send(:include, Rubycas::Helper)


# Ensure we get a recent version of nginx
node.default[:nginx][:version]            = '1.4.4'
node.default[:nginx][:source][:version]   = node[:nginx][:version]
node.default[:nginx][:source][:prefix]    = "/opt/nginx-#{node[:nginx][:version]}"
node.default[:nginx][:source][:checksum]  = '7c989a58e5408c9593da0bebcd0e4ffc3d892d1316ba5042ddb0be5b0b4102b9'
node.default[:nginx][:source][:url]       = "http://nginx.org/download/nginx-#{node[:nginx][:version]}.tar.gz"
node.default[:nginx][:source][:sbin_path] = "#{node[:nginx][:source][:prefix]}/sbin/nginx"

node.default[:nginx][:source][:default_configure_flags] = [
  "--prefix=#{node[:nginx][:source][:prefix]}",
  "--conf-path=#{node[:nginx][:dir]}/nginx.conf"
]

# Add in extra modules for load balancer support
node.default[:nginx][:source][:modules] << 'nginx::http_realip_module'

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
