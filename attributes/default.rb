
# system ruby
default[:rubycas][:ruby_version] = 'ruby-1.9.3-p448'

# rubycas application defaults
default[:rubycas][:dir] = '/home/rubycas'
default[:rubycas][:app_directory] = "#{node[:rubycas][:dir]}/rubycas-server"
default[:rubycas][:user] = 'rubycas'

default[:rubycas][:git][:branch] = 'efd533fd958ea90b5c32be21467053c5bacb3223'
default[:rubycas][:git][:url] = 'https://github.com/rubycas/rubycas-server'

default[:rubycas][:application_server] = 'unicorn'
default[:rubycas][:default_server] = true
default[:rubycas][:https] = true
default[:rubycas][:nginx] = true
default[:rubycas][:port] = node[:rubycas][:https] ? 443 : 80
default[:rubycas][:ssl_cert] = "/etc/nginx/#{node[:fqdn]}.crt"
default[:rubycas][:ssl_key] = "/etc/nginx/#{node[:fqdn]}.key"
default[:rubycas][:ssl_req] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node[:fqdn]}/emailAddress=root@localhost"
default[:rubycas][:server_name] = 'rubycas.local'
default[:rubycas][:uri_path] = "/cas"

default[:rubycas][:database][:type] = 'mysql'
default[:rubycas][:database][:adapter] = node[:rubycas][:database][:type] == 'mysql' ? 'mysql2' : 'postgresql'
default[:rubycas][:database][:adapter_gem] = node[:rubycas][:database][:type] == 'mysql' ? 'mysql2' : 'pg'
default[:rubycas][:database][:database] = 'rubycas'
default[:rubycas][:database][:host] = 'localhost'
default[:rubycas][:database][:reconnect] = true
default[:rubycas][:database][:user] = 'rubycas'
