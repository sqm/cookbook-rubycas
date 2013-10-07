
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
default[:rubycas][:nginx] = true
default[:rubycas][:port] = 443

# ssl
default[:rubycas][:ssl][:ssl_cert] = "/etc/nginx/#{node[:fqdn]}.crt"
default[:rubycas][:ssl][:ssl_key] = "/etc/nginx/#{node[:fqdn]}.key"
default[:rubycas][:ssl][:data_bag] = 'rubycas'
default[:rubycas][:ssl][:data_bag_item] = 'ssl'

# authenticators
default[:rubycas][:authenticators][:data_bag] = 'rubycas'
default[:rubycas][:authenticators][:data_bag_item] = 'authenticator'

# uris
default[:rubycas][:server_name] = 'rubycas.local'
default[:rubycas][:uri_path] = ''

# database
default[:rubycas][:database][:data_bag] = 'rubycas'
default[:rubycas][:database][:data_bag_item] = 'database'
default[:rubycas][:database][:reconnect] = true

