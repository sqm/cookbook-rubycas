module Rubycas
  module Helper
    module PostgresDatabase
      def database_adapter_gem
        'pg'
      end

      def database_provider
        Chef::Provider::Database::Postgresql
      end

      def database_user_provider
        Chef::Provider::Database::PostgresqlUser
      end

      def node_root_password
        node[:postgresql][:password][:postgres]
      end

      def required_recipes
        %w{
          postgresql::server
          database::postgresql
        }
      end

      def required_client_recipes
        %w{
          postgresql::ruby
        }
      end
    end
  end
end
