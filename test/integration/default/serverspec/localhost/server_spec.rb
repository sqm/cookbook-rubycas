require 'spec_helper'

describe 'rubycas::server' do
  describe command('/usr/local/rvm/rubies/ruby-1.9.3-p448/bin/ruby -v') do
    it { should return_exit_status 0 }
  end

  describe user('rubycas') do
    it { should exist }
    it { should belong_to_group 'rvm' }
    it { should have_home_directory '/home/rubycas' }
  end

  describe file("/home/rubycas/.bashrc") do
    it { should be_file }
    it { should be_owned_by 'rubycas' }
  end

  describe file('/home/rubycas/rubycas-server') do
    it { should be_directory }
    it { should be_owned_by 'rubycas' }
  end

  describe file('/home/rubycas/rubycas-server/config.yml') do
    it { should be_file }
    it { should be_owned_by 'rubycas' }
  end

  describe file('/home/rubycas/rubycas-server/Gemfile') do
    it { should be_file }
    it { should be_owned_by 'rubycas' }
  end

  describe file('/usr/bin/god') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe file('/etc/god/conf.d/rubycas.god') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe service('god') do
    it { should be_running }
  end

  describe service('production-unicorn') do
    it { should be_monitored_by('god')  }
  end
end
