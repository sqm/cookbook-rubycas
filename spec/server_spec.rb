require_relative 'spec_helper'

describe 'rubycas::server' do
  before(:each) do
    @chef_run                       = ChefSpec::Runner.new(CHEF_RUN_OPTIONS)
    @chef_run.node.set[:mysql]      = MYSQL_ATTRIBUTE_OPTIONS
    @chef_run.node.set[:postgres]   = POSTGRES_ATTRIBUTE_OPTIONS
    stub_data_bag_item("rubycas", "authenticator").and_return(rubycas_authenticator_data_bag_item)
    stub_data_bag_item("rubycas", "database").and_return(rubycas_database_data_bag_item)

    # stub out command from rvm cookbook
    stub_command("bash -c \"source /etc/profile && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"").and_return(true)
    @chef_run_with_converge = @chef_run.converge 'rubycas::server'
  end

  let(:rubycas_authenticator_data_bag_item) {
    {"authenticators"=> [
    {"authenticator"=> {
        "class"=> "CASServer::Authenticators::SQLAuthlogic",
        "database"=> {
          "adapter"=> "mysql2",
          "database"=>  "viper_cms",
          "username"=>  "root",
          "password"=>  "",
          "host"=> "33.33.33.1"},
        "user_table"=> "admin_users",
        "username_column"=> "login",
        "password_column"=> "crypted_password",
        "salt_column"=> "password_salt",
        "encryptor_options"=> {
          "stretches"=> 20,
          "digest_format"=> "--PASSWORD--SALT--"}
      }
    }
  ]}
  }

  let(:rubycas_database_data_bag_item) {
    { "adapter"       =>  "mysql2",
      "database_type" =>  "mysql",
      "host"          =>  "database.example.com",
      "id"            =>  "database",
      "name"          =>  "rubycas",
      "password"      =>  "database_password",
      "port"          =>  "3306",
      "username"      =>  "rubycas" }
  }


  it "should include the rvm::system-install recipe" do
    expect(@chef_run_with_converge).to include_recipe 'rvm::system_install'
  end

  it "should add the application user" do
    expect(@chef_run_with_converge).to create_user @chef_run.node[:rubycas][:user]
  end

  it "should add a bash.rc file with rvm for the application user" do
    expect(@chef_run_with_converge).to create_file_with_content(
      "#{@chef_run.node[:rubycas][:dir]}/.bashrc",
      "source #{@chef_run.node[:rvm][:root_path]}/environments/#{@chef_run.node[:rubycas][:ruby_version]}"
    )
  end

  it "should create the config.yml file" do
    expect(@chef_run_with_converge).to create_template "#{@chef_run.node[:rubycas][:app_directory]}/config.yml"
  end

  it "should create the Gemfile file" do
    expect(@chef_run_with_converge).to create_template "#{@chef_run.node[:rubycas][:app_directory]}/Gemfile"
  end

  it "should include the god recipe" do
    expect(@chef_run_with_converge).to include_recipe 'god::default'
  end

  it "should install nginx" do
    pending
  end

  it "should create the nginx configuration file" do
    pending
  end
end
