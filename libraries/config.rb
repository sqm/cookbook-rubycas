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
    end
  end
end
