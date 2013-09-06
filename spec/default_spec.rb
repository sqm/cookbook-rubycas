require_relative 'spec_helper'

describe 'rubycas-server::default' do
  before(:each) do
    @chef_run                       = ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS)
    @chef_run.node.set[:mysql]      = MYSQL_ATTRIBUTE_OPTIONS
    @chef_run.node.set[:postgresql] = POSTGRES_ATTRIBUTE_OPTIONS
    @chef_run_with_converge = @chef_run.converge 'rubycas-server::default'
  end

  it "should include the rvm::system-install recipe" do
    expect(@chef_run_with_converge).to include_recipe 'rvm::system_install'
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
    xit "should include the postres recipe" do
      expect(@chef_run_with_converge).to include_recipe 'postgresql::server'
    end

    xit "should include the database recipe" do
      expect(@chef_run_with_converge).to include_recipe 'database::postgresql'
    end
  end

  it "should add the application user" do
    expect(@chef_run_with_converge).to create_user @chef_run.node[:rubycas][:user]
  end

  it "should add a bash profile with rvm for the application user" do
    expect(@chef_run_with_converge).to create_file_with_content(
      "#{@chef_run.node[:rubycas][:dir]}/.bashrc",
      "source #{@chef_run.node[:rvm][:root_path]}/environments/#{@chef_run.node[:rubycas][:ruby_version]}"
    )
  end

  it "should create the config.yml file" do
    expect(@chef_run_with_converge).to create_file "#{@chef_run.node[:rubycas][:app_directory]}/config/config.yml"
  end

  it "should create the Gemfile file" do
    expect(@chef_run_with_converge).to create_file "#{@chef_run.node[:rubycas][:app_directory]}/Gemfile"
  end

  it "should install nginx" do
    pending
  end

  it "should create the nginx configuration file" do
    pending
  end
end
