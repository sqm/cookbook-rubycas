module Rubycas
  module Helper
    class Config
      attr_reader :config, :node

      def initialize(config, node)
        @config = config
        @node = node
      end

      def method_missing(method, *args, &block)
        config[method.to_s]
      end

      def respond_to_missing?(method, include_private = false)
        config.has_key?(method.to_s) || super
      end
    end
  end
end
