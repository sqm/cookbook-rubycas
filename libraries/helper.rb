module Rubycas
  module Helper
    def search_for_database_config
      DatabaseConfig.new(data_bag_item(node[:rubycas][:database][:data_bag], node[:rubycas][:database][:data_bag_item]), node)
    end

    def search_for_ssl_config
      SSLConfig.new(data_bag_item(node[:rubycas][:ssl][:data_bag], node[:rubycas][:ssl][:data_bag_item]), node)
    end

    def search_for_authenticators_config
      AuthenticatorsConfig.new(data_bag_item(node[:rubycas][:authenticators][:data_bag], node[:rubycas][:authenticators][:data_bag_item]), node)
    end

    class Config
      attr_reader :config, :node

      def initialize(config, node)
        @config = config
        @node = node
      end

      def method_missing(method, *args, &block)
        if config.has_key? method.to_s
          return config[method.to_s]
        else
          super
        end
      end

      def respond_to?(method, include_private = false)
        if config.has_key? method.to_s
          return true
        else
          super
        end
      end
    end

    class DatabaseConfig < Config
      def use_mysql?
        config['database_type'] == 'mysql'
      end

      def database_adapter_gem
        use_mysql? ? 'mysql2' : 'pg'
      end

      def database_provider
        use_mysql? ? Chef::Provider::Database::Mysql : Chef::Provider::Database::Postgresql
      end

      def database_user_provider
        use_mysql? ? Chef::Provider::Database::MysqlUser : Chef::Provider::Database::PostgresqlUser
      end

      def node_root_password
        use_mysql? ? node[:mysql][:server_root_password] : node[:postgresql][:password][:postgres]
      end
    end

    class SSLConfig < Config
      def use_ssl?
        node[:use_ssl]
      end

      def cert_file_path
        node[:rubycas][:ssl][:ssl_cert]
      end

      def key_file_path
        node[:rubycas][:ssl][:ssl_key]
      end
    end

    class AuthenticatorsConfig < Config
    end
  end
end
