require_relative 'spec_helper'

describe 'rubycas::database' do
  before(:each) do
    @chef_run                       = ChefSpec::Runner.new(CHEF_RUN_OPTIONS)
    @chef_run.node.set[:mysql]      = MYSQL_ATTRIBUTE_OPTIONS
    @chef_run.node.set[:postgres]   = POSTGRES_ATTRIBUTE_OPTIONS

    # stub rubycas database databag search
    stub_data_bag_item("rubycas", "database").and_return(rubycas_database_data_bag)

    # stub out MySQL command
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return(true)

    @chef_run_with_converge = @chef_run.converge 'rubycas::database'
  end

  let(:rubycas_database_data_bag) {
    { "adapter"       =>  "mysql2",
      "database_type" =>  "mysql",
      "host"          =>  "database.example.com",
      "id"            =>  "database",
      "name"          =>  "rubycas",
      "password"      =>  "database_password",
      "port"          =>  "3306",
      "username"      =>  "rubycas" }
  }

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
      @chef_run = ChefSpec::Runner.new(CHEF_RUN_OPTIONS)
      @chef_run.node.set[:rubycas][:database][:type] = 'postgres'
      @chef_run.node.set[:mysql]      = MYSQL_ATTRIBUTE_OPTIONS
      @chef_run.node.set[:postgresql] = POSTGRES_ATTRIBUTE_OPTIONS
      @chef_run_with_converge = @chef_run.converge 'rubycas::database'
    end

    it "should test for postgresql resources" do
      pending
    end
  end
end
