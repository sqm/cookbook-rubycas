require_relative 'spec_helper'

describe 'rubycas::database' do
  let(:chef_run)          { ChefSpec::Runner.new(CHEF_RUN_OPTIONS) }
  let(:chef_run_converge) { chef_run.converge described_recipe }

  context "When using MySQL Database" do
    before(:each) do
      chef_run.node.set[:rubycas][:database][:type] = 'mysql'
      chef_run.node.set[:mysql] = MYSQL_ATTRIBUTE_OPTIONS

      # stub rubycas MySQL database databag search
      stub_data_bag_item("rubycas", "database").and_return(rubycas_mysql_database_data_bag)

      # stub out MySQL command
      stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return(true)
    end

    # use example data bag for mysql
    let(:rubycas_mysql_database_data_bag) { load_databag_json('database.json') }

    it "should include the mysql::server recipe" do
      expect(chef_run_converge).to include_recipe 'mysql::server'
    end

    it "should include the database::mysql recipe" do
      expect(chef_run_converge).to include_recipe 'database::mysql'
    end
  end

  context "When using PostgreSQL Database" do
    before(:each) do
      chef_run.node.set[:rubycas][:database][:type] = 'postgres'
      chef_run.node.set[:postgresql] = POSTGRES_ATTRIBUTE_OPTIONS

      # stub rubycas database databag search
      stub_data_bag_item("rubycas", "database").and_return(rubycas_postgres_database_data_bag)
    end

    let(:rubycas_postgres_database_data_bag) {
      { "adapter"       =>  "pg",
        "database_type" =>  "postgres",
        "host"          =>  "database.example.com",
        "id"            =>  "database",
        "name"          =>  "rubycas",
        "password"      =>  "database_password",
        "port"          =>  "3306",
        "username"      =>  "rubycas" }
    }

    it "should include the postgresql::server recipe" do
      expect(chef_run_converge).to include_recipe 'postgresql::server'
    end

    it "should test for database::postresql recipe" do
      expect(chef_run_converge).to include_recipe 'database::postgresql'
    end
  end
end
