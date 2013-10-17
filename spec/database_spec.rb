require_relative 'spec_helper'

describe 'rubycas::database' do
  before(:each) do
    @chef_run                       = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS)
    @chef_run.node.set[:mysql]      = MYSQL_ATTRIBUTE_OPTIONS
    @chef_run.node.set[:postgres]   = POSTGRES_ATTRIBUTE_OPTIONS
    @chef_run_with_converge = @chef_run.converge 'rubycas::database'
  end

  context "When using MySQL Database" do
    it "should include the mysql recipe" do
      expect(@chef_run_with_converge).to include_recipe 'mysql::server'
    end

    it "should include the database recipe" do
      expect(@chef_run_with_converge).to include_recipe 'database::mysql'
    end
  end

  context "When using PostgreSQL Database" do
    before(:each) do
      @chef_run = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS)
      @chef_run.node.set[:rubycas][:database][:type] = 'postgres'
      @chef_run.node.set[:postgresql] = POSTGRES_ATTRIBUTE_OPTIONS
      @chef_run_with_converge = @chef_run.converge 'rubycas::database'
    end

    it "should include the postres recipe" do
      expect(@chef_run_with_converge).to include_recipe 'postgresql::server'
    end

    it "should include the database recipe" do
      expect(@chef_run_with_converge).to include_recipe 'database::postgresql'
    end
  end
end
