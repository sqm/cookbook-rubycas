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

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.define "rubycas" do |rubycas|
    rubycas.vm.hostname = "rubycas-server-berkshelf"
    rubycas.vm.network :private_network, ip: "33.33.33.10"
    rubycas.vm.provision :chef_solo do |chef|
      chef.data_bags_path = 'data_bags'
      chef.json = {}

      chef.run_list = [
        "recipe[rubycas-server::default]",
        "recipe[rubycas-server::nginx]"
      ]
    end
  end

  config.vm.define "mysql" do |mysql|
    mysql.vm.hostname = "mysql-server-berkshelf"
    mysql.vm.network :private_network, ip: "33.33.33.11"
    mysql.vm.provision :chef_solo do |chef|
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
        "recipe[rubycas-server::database]",
      ]
    end
  end
end
