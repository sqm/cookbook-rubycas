module Rubycas
  module Helper
    class SSLConfig < Config
      def cert_file_path
        node[:rubycas][:ssl][:ssl_cert]
      end

      def key_file_path
        node[:rubycas][:ssl][:ssl_key]
      end
    end
  end
end
