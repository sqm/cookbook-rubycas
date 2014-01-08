require 'spec_helper'

nginx_dir = '/opt/nginx-1.4.4'

describe 'rubycas::server' do
  describe file(nginx_dir) do
    it { should be_directory }
    it { should be_owned_by 'root' }
  end

  describe command("#{nginx_dir}/sbin/nginx -V") do
    it { should return_exit_status 0 }
  end

  describe command("#{nginx_dir}/sbin/nginx -V  2>&1 | grep '\\-\\-with-http_realip_module'") do
    it "should have the Nginx http_realip_module compiled" do
      should return_exit_status 0
    end
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

  describe file('/etc/logrotate.d/nginx') do
    it { should be_file }
  end
end
