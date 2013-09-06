#
# Cookbook Name:: rubycas-server
# Recipe:: database
#

database_type = node[:rubycas][:database][:type]
database_provider = database_type == 'mysql' ? Chef::Provider::Database::Mysql : Chef::Provider::Database::Postgresql
database_user_provider = database_type == 'mysql' ? Chef::Provider::Database::MysqlUser : Chef::Provider::Database::PostgresqlUser

# Add Database resources
if database_type == 'mysql'
  db_recipes = %w{
    mysql::server
    database::mysql
  }

  # database connection info
  database_connection_info = {
    :host => 'localhost',
    :username => 'root',
    :password => node[:mysql][:server_root_password]
  }

else
  db_recipes = %w{
    postgresql::server
    database::postgresql
  }

  # database connection info
  database_connection_info = {
    :host => 'localhost',
    :username => 'root',
    :port => '5432',
    :password => node[:postgresql][:password][:postgres]
  }
end

# Include recipes for the database server
db_recipes.each { |recipe| include_recipe recipe }

# Enable secure password generation
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:rubycas][:database][:password] = secure_password

# Save the node data unless using Chef-Solo
ruby_block 'save node data' do
  block do
    node.save
  end
  not_if { Chef::Config[:solo] }
end

# Create rubycas database
database node[:rubycas][:database][:database] do
  connection database_connection_info
  provider database_provider
  action :create
end

# Create rubycas database user
database_user node[:rubycas][:user] do
  connection database_connection_info
  database_name node[:rubycas][:database][:database]
  password node[:rubycas][:database][:password]
  provider database_user_provider
  action :create
end

# Grant privileges for rubycas database user
database_user node[:rubycas][:user] do
  connection database_connection_info
  database_name node[:rubycas][:database][:database]
  password node[:rubycas][:database][:password]
  provider database_user_provider
  host '%'
  action :grant
end
