require 'spec_helper'

describe 'rubycas::database' do
  describe port(5432) do
    it { should be_listening }
  end

  describe package('postgresql-9.1') do
    it { should be_installed }
  end
end
