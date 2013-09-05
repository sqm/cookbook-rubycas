require_relative 'spec_helper'

describe 'rubycas-server::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new(CHEF_RUN_OPTIONS).converge 'rubycas-server::default' }

  it "should include the rvm::system-install recipe" do
   expect(chef_run).to include_recipe 'rvm::system_install'
  end

  it "should add the application user" do
    expect(chef_run).to create_user chef_run.node[:rubycas][:user]
  end

  it "should add a bash profile with rvm for the application user" do
    expect(chef_run).to create_file_with_content(
      "#{chef_run.node[:rubycas][:dir]}/.bashrc",
      "source #{chef_run.node[:rvm][:root_path]}/environments/#{chef_run.node[:rubycas][:ruby_version]}"
    )
  end
end
