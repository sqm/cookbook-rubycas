require File.join(File.dirname(__FILE__), 'config')

module Rubycas
  module Helper
    class DatabaseConfig < Config
      def initialize(config, node)
        mixin_constant = Rubycas::Helper.const_get("#{config['database_type'].capitalize}Database")
        extend mixin_constant
        super
      end

      def database_adapter_gem
        raise "Concrete class must implement #database_adapter_gem"
      end

      def database_provider
        raise "Concrete class must implement #database_provider"
      end

      def database_user_provider
        raise "Concrete class must implement #database_user_provider"
      end

      def node_root_password
        raise "Concrete class must implement #node_root_password"
      end

      def required_recipes
        raise "Concrete class must implement #required_recipes"
      end

      def required_client_recipes
        raise "Concreate class must implement #required_client_recipes"
      end
    end
  end
end
