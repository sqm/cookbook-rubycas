
# system ruby
default[:rubycas][:ruby_version] = 'ruby-1.9.3-p448'

# rubycas application
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

# ssl
default[:rubycas][:ssl][:ssl_cert] = "/etc/nginx/#{node[:fqdn]}.crt"
default[:rubycas][:ssl][:ssl_key] = "/etc/nginx/#{node[:fqdn]}.key"
default[:rubycas][:ssl][:ssl_req] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node[:fqdn]}/emailAddress=root@localhost"
default[:rubycas][:ssl][:databag] = 'rubycas'
default[:rubycas][:ssl][:databag_item] = 'ssl'

# authenticators
default[:rubycas][:authenticators][:databag] = 'rubycas'
default[:rubycas][:authenticators][:databag_item] = 'authenticator'

# uris
default[:rubycas][:server_name] = 'rubycas.local'
default[:rubycas][:uri_path] = '/cas'

# database
default[:rubycas][:database][:databag] = 'rubycas'
default[:rubycas][:database][:databag_item] = 'database'
default[:rubycas][:database][:reconnect] = true

