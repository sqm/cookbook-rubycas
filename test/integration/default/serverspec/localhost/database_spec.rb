require 'spec_helper'

describe 'rubycas::database' do
  describe port(3306) do
    it { should be_listening }
  end

  describe package('mysql-server') do
    it { should be_installed }
  end
end
