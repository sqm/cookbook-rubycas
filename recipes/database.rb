#
# Cookbook Name:: rubycas-server
# Recipe:: database
#

::Chef::Recipe.send(:include, Rubycas::Helper)

db_config = search_for_database_config

# Add Database resources
db_config.required_recipes.each do |recipe|
  include_recipe recipe
end

# database connection info
database_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :port => db_config.port,
  :password => db_config.node_root_password
}

# Create rubycas database
database db_config.name do
  connection database_connection_info
  provider db_config.database_provider
  action :create
end

# Create rubycas database user
database_user db_config.username do
  connection database_connection_info
  database_name db_config.name
  password db_config.password
  provider db_config.database_user_provider
  action :create
end

# Grant privileges for rubycas database user
database_user db_config.username do
  connection database_connection_info
  database_name db_config.name
  password db_config.password
  provider db_config.database_user_provider
  host '%'
  action :grant
end
