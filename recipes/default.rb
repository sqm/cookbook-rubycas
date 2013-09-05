#
# Cookbook Name:: rubycas-server
# Recipe:: default
#

include_recipe 'rvm::system_install'
rvm_environment node[:rubycas][:ruby_version]

user node[:rubycas][:user] do
  home     node[:rubycas][:dir]
  comment  'RubyCAS Application User'
  supports :manage_home => true
  shell    '/bin/bash'
end

template "#{node[:rubycas][:dir]}/.bashrc" do
  source "bashrc.erb"
  mode   0644
  owner  node[:rubycas][:user]
  group  node[:rubycas][:user]
  variables(
    :ruby_bin => "#{node[:rvm][:root_path]}/environments/#{node[:rubycas][:ruby_version]}"
  )
end
