module Rubycas
  module Helper
    class Config
      attr_reader :config, :node

      def initialize(config, node)
        @config = config
        @node = node
      end

      def method_missing(method, *args, &block)
        return config[method.to_s] if config.has_key? method.to_s

        super
      end
    end
  end
end
