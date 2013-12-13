require_relative 'spec_helper'

describe 'rubycas::server' do
  let(:chef_run)          { ChefSpec::Runner.new(CHEF_RUN_OPTIONS) }
  let(:chef_run_converge) { chef_run.converge described_recipe }

  before(:each) do
    chef_run.node.set[:mysql] = MYSQL_ATTRIBUTE_OPTIONS
    stub_data_bag_item("rubycas", "authenticator").and_return(rubycas_authenticator_data_bag_item)
    stub_data_bag_item("rubycas", "database").and_return(rubycas_database_data_bag_item)

    # stub out command from rvm cookbook
    stub_command("bash -c \"source /etc/profile && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"").and_return(true)

    chef_run.converge described_recipe
  end

  # use example data bags
  let(:rubycas_database_data_bag_item)      { load_databag_json('database.json') }
  let(:rubycas_authenticator_data_bag_item) { load_databag_json('authenticator.json') }

  it "should include the rvm::system-install recipe" do
    expect(chef_run_converge).to include_recipe 'rvm::system_install'
  end

  it "should add the application user" do
    expect(chef_run_converge).to create_user chef_run.node[:rubycas][:user]
  end

  it "should modify the rvm group" do
    expect(chef_run_converge).to modify_group "rvm"
  end

  it "should add a bash.rc file with rvm for the application user" do
    expect(chef_run_converge).to render_file("#{chef_run.node[:rubycas][:dir]}/.bashrc").with_content(
      "source #{chef_run.node[:rvm][:root_path]}/environments/#{chef_run.node[:rubycas][:ruby_version]}"
    )
  end

  it "should checkout the RubyCAS application from the git repository" do
    expect(chef_run_converge).to checkout_git(chef_run.node[:rubycas][:app_directory]).with(
      repository: chef_run.node[:rubycas][:git][:url]
    )
  end

  rubycas_app_directory = '/home/rubycas/rubycas-server'

  [
    "#{rubycas_app_directory}/tmp",
    "#{rubycas_app_directory}/tmp/pids",
    "#{rubycas_app_directory}/tmp/sockets"
  ].each do |dir|
    it "should create the #{dir} owned by the rubycas user" do
      expect(chef_run_converge).to create_directory(dir).with(
        user:  chef_run.node[:rubycas][:user],
        group: chef_run.node[:rubycas][:user]
      )
    end
  end

  it "should create the config.yml for the RubyCAS application file owned by the rubycas user" do
    expect(chef_run_converge).to create_template("#{chef_run.node[:rubycas][:app_directory]}/config.yml").with(
      user:  chef_run.node[:rubycas][:user],
      group: chef_run.node[:rubycas][:user]
    )
  end

  it "should create the Gemfile file for the RubyCAS application owned by the rubycas user" do
    expect(chef_run_converge).to create_template("#{chef_run.node[:rubycas][:app_directory]}/Gemfile").with(
      user:  chef_run.node[:rubycas][:user],
      group: chef_run.node[:rubycas][:user]
    )
  end

  it "should create a wrapper script for god owned by the root user" do
    expect(chef_run_converge).to create_template("/usr/bin/god").with(
      user:  'root',
      group: 'root'
    )
  end

  it "should include the god::default recipe" do
    expect(chef_run_converge).to include_recipe 'god::default'
  end

  it "should create the rubycas.god template owned by the root user" do
    expect(chef_run_converge).to create_template("/etc/god/conf.d/rubycas.god").with(
      user:  'root',
      group: 'root'
    )
  end
end
