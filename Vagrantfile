# -*- mode: ruby -*-
# vi: set ft=ruby :

MEMORY = ENV['VAGRANT_MEMORY'] || '512'
CORES  = ENV['VAGRANT_CORES']  || '1'

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  
   config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", MEMORY.to_i]
     vb.customize ["modifyvm", :id, "--cpus", CORES.to_i]
   end

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  config.berkshelf.enabled = true

  config.vm.provision :shell, :path => "script/bootstrap.sh"

  config.vm.define "database" do |database|
    database.vm.hostname = "rubycas-database-server-berkshelf"
    database.vm.network :private_network, ip: "33.33.33.11"
    database.vm.provision :chef_solo do |chef|
      chef.data_bags_path = 'data_bags'
      chef.json = {
        :mysql => {
          :server_root_password => 'rootpass',
          :server_debian_password => 'debpass',
          :server_repl_password => 'replpass',
          :bind_address => '33.33.33.11'
        },
        :postgresql => {
          :password => {
            :postgres => '123456'
          }
        },
        :rubycas => {
          :database => {
            :password => 'pass'
          }
        }
      }

      chef.run_list = [
        "recipe[rubycas::database]",
      ]
    end
    database.vm.provision :shell, :path => "script/create_mock_authenticator_db.sh"
  end

  config.vm.define "app" do |app|
    app.vm.hostname = "rubycas-app-server-berkshelf"
    app.vm.network :private_network, ip: "33.33.33.10"
    app.vm.provision :chef_solo do |chef|
      chef.data_bags_path = 'data_bags'
      chef.json = {}

      chef.run_list = [
        "recipe[rubycas::server]",
        "recipe[rubycas::nginx]"
      ]
    end
  end
end
