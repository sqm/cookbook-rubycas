# RubyCAS Cookbook

Installs and configures a [RubyCAS Server](https://github.com/rubycas/rubycas-server)

## Recipes

* `rubycas::database` - Installs and configures a database for RubyCAS Server. 
* `rubycas::default`  - Default noop cookbook recipe. 
* `rubycas::nginx`    - Installs and conifgures the Nginx Web Server for the application. 
* `rubycas::server`   - Installs and conifgures the RubyCAS Server application. 

## Development

Development requires [Vagrant](http://vagrantup.com).

Get up and running quickly with the following these steps.

```bash
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus
git clone git@github.com:sqm/cookbook-rubycas.git
cd cookbook-rubycas
vagrant up
```

Access the VMs via the following commands:

* `vagrant ssh app` for the application VM.
* `vagrant ssh database` for the database VM.

## Contributing

1. Fork repository on GitHub.
1. Create a feature branch (should indicate intention `add_feature_x`).
1. Make changes.
1. Test changes.
1. Ensure all tests pass.
1. Submit pull request using GitHub.

Do not modify `metadata.rb`, the maintainers will handle those changes.

## Author

Author:: Squaremouth (<devops@squaremouth.com>)
