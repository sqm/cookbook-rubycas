
# system ruby
default[:rubycas][:ruby_version] = 'ruby-1.9.3-p448'

# rubycas application defaults
default[:rubycas][:user]          = 'rubycas'
default[:rubycas][:dir]           = '/home/rubycas'
default[:rubycas][:app_directory] = "#{node[:rubycas][:dir]}/rubycas-server"

default[:rubycas][:git][:url]    = 'https://github.com/rubycas/rubycas-server'
default[:rubycas][:git][:branch] = '1.1.1'

default[:rubycas][:application_server] = 'unicorn'
default[:rubycas][:https]              = true
default[:rubycas][:port]               = node[:rubycas][:https] ? 443 : 80
default[:rubycas][:ssl_cert]           = "/etc/nginx/#{node[:fqdn]}.crt"
default[:rubycas][:ssl_key]            = "/etc/nginx/#{node[:fqdn]}.key"
default[:rubycas][:uri_path]           = "/cas"

default[:rubycas][:database][:database]    = 'rubycas'
default[:rubycas][:database][:type]        = 'mysql'
default[:rubycas][:database][:adapter]     = node[:rubycas][:database][:type] == 'mysql' ? 'mysql2' : 'postgresql'
default[:rubycas][:database][:adapter_gem] = node[:rubycas][:database][:type] == 'mysql' ? 'mysql2' : 'pg'
default[:rubycas][:database][:host]        = 'localhost'
default[:rubycas][:database][:user]        = 'rubycas'
default[:rubycas][:database][:reconnect]   = true

