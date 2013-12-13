require_relative 'spec_helper'

describe 'rubycas::nginx' do
  let(:chef_run)          { ChefSpec::Runner.new(CHEF_RUN_OPTIONS) }
  let(:chef_run_converge) { chef_run.converge described_recipe }

  # use example data bag
  let(:ssl_data_bag) { load_databag_json('ssl.json') }

  before(:each) do
    # required because of the nginx::source recipe
    Chef::Config[:config_file] = '/dev/null'

    # stub rubycas ssl databag
    stub_data_bag_item("rubycas", "ssl").and_return(ssl_data_bag)
  end

  it "should include the nginx::source recipe" do
    expect(chef_run_converge).to include_recipe 'nginx::source'
  end

  %w{ crt key }.each do |file|
    it "should create the ssl certificate #{file} file" do
      expect(chef_run_converge).to create_file("/etc/nginx/#{chef_run.node[:fqdn]}.#{file}")
    end
  end

  it "should create the nginx sites-enabled template for rubycas" do
    expect(chef_run_converge).to create_template('/etc/nginx/sites-enabled/rubycas')
  end
end
