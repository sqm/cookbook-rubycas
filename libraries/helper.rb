require File.join(File.dirname(__FILE__), 'authenticators_config')
require File.join(File.dirname(__FILE__), 'database_config')
require File.join(File.dirname(__FILE__), 'ssl_config')

module Rubycas
  module Helper
    def search_for_database_config
      DatabaseConfig.new(
        data_bag_item(node[:rubycas][:database][:data_bag], node[:rubycas][:database][:data_bag_item]),
        node
      )
    end

    def search_for_ssl_config
      SSLConfig.new(
        data_bag_item(node[:rubycas][:ssl][:data_bag], node[:rubycas][:ssl][:data_bag_item]),
        node
      )
    end

    def search_for_authenticators_config
      AuthenticatorsConfig.new(
        data_bag_item(node[:rubycas][:authenticators][:data_bag], node[:rubycas][:authenticators][:data_bag_item]),
        node
      )
    end
  end
end
