module Rubycas
  module Helper
    def database_config_from_databag
      @_database_config ||= data_bag_item(node[:rubycas][:database][:databag], node[:rubycas][:database][:databag_item])
    end

    def database_adapter_gem
      database_config["adapter"] == 'mysql2' ? 'mysql2' : 'pg'
    end
  end
end
