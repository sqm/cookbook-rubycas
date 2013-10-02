#
# Cookbook Name:: rubycas-server
# Recipe:: database
#

::Chef::Recipe.send(:include, Rubycas::Helper)

db_config = database_config_from_databag

database_type = database_config["type"]
database_provider = database_type == 'mysql' ? Chef::Provider::Database::Mysql : Chef::Provider::Database::Postgresql
database_user_provider = database_type == 'mysql' ? Chef::Provider::Database::MysqlUser : Chef::Provider::Database::PostgresqlUser

# Add Database resources
if database_type == 'mysql'
  %w{
    mysql::server
    database::mysql
  }.each do |recipe|
    include_recipe recipe
  end

  # database connection info
  database_connection_info = {
    :host => 'localhost',
    :username => 'root',
    :password => node[:mysql][:server_root_password]
  }

else
  %w{
    postgresql::server
    database::postgresql
  }.each do |recipe|
    include_recipe recipe
  end

  # database connection info
  database_connection_info = {
    :host => 'localhost',
    :username => 'root',
    :port => '5432',
    :password => node[:postgresql][:password][:postgres]
  }
end

# Create rubycas database
database db_config["name"] do
  connection database_connection_info
  provider database_provider
  action :create
end

# Create rubycas database user
database_user db_config["username"] do
  connection database_connection_info
  database_name db_config["name"]
  password db_config["password"]
  provider database_user_provider
  action :create
end

# Grant privileges for rubycas database user
database_user db_config["username"] do
  connection database_connection_info
  database_name db_config["name"]
  password db_config["password"]
  provider database_user_provider
  host '%'
  action :grant
end
