require 'chefspec'

CHEF_RUN_OPTIONS = {
  :platform  => 'ubuntu',
  :version   => '12.04',
  :log_level => :error
}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
