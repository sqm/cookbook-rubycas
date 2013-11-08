Installs and configures a [RubyCAS Server](https://github.com/rubycas/rubycas-server)

The `vagrant-berkshelf` and `vagrant-omnibus` plugins are both necessary to use Vagrant for development of this cookbook, and can be installed with the commands:

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-omnibus

# Recipes

* `rubycas::database` - Installs and configures a database for RubyCAS Server. 
* `rubycas::default`  - Default noop cookbook recipe. 
* `rubycas::nginx`    - Installs and conifgures the Nginx Web Server for the application. 
* `rubycas::server`   - Installs and conifgures the RubyCAS Server application. 

# Author

Author:: Squaremouth (<devops@squaremouth.com>)
