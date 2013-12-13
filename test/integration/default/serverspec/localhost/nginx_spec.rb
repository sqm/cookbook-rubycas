require 'spec_helper'

describe 'rubycas::server' do
  describe file('/opt/nginx-1.2.9') do
    it { should be_directory }
    it { should be_owned_by 'root' }
  end

  describe command('/opt/nginx-1.2.9/sbin/nginx -V') do
    it { should return_exit_status 0 }
  end

  describe port(80) do
    it {should be_listening }
  end

  describe port(443) do
    it {should be_listening }
  end

  describe service('nginx') do
    it { should be_running }
  end

  describe file('/etc/nginx/sites-enabled/rubycas') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end
end
