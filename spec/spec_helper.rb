require 'chefspec'
require 'multi_json'
require 'pry'
require 'pry-remote'

CHEF_RUN_OPTIONS = {
  :platform  => 'ubuntu',
  :version   => '12.04',
  :log_level => :error
}

MYSQL_ATTRIBUTE_OPTIONS = {
  :server_root_password    => 'rootpass',
  :server_debian_password  => 'debpass',
  :server_repl_password    => 'replpass'
}

POSTGRES_ATTRIBUTE_OPTIONS = {
  :password => {
    :postgres => 'kjsdhgkj'
  }
}

# load example data bag item JSON file
def load_databag_json(filename)
  File.open(File.expand_path("../../data_bags/rubycas/#{filename}", __FILE__), "r") { |f| JSON.load(f) }
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
