# RubyCAS Cookbook

Installs and configures a [RubyCAS Server](https://github.com/rubycas/rubycas-server)

## Recipes

* `rubycas::database` - Installs and configures a database for RubyCAS Server. 
* `rubycas::default`  - Default noop cookbook recipe. 
* `rubycas::nginx`    - Installs and configures the Nginx Web Server for the application. 
* `rubycas::server`   - Installs and configures the RubyCAS Server application. 

## Load Balancer Support
If you need to deploy your RubyCAS server behind a load balancer, you
will need to set these attributes:

* `node[:rubycas][:is_load_balanced] = true`
* `node[:rubycas][:load_balancer_ip] = '192.0.0.0/8'`

The `node[:rubycas][:load_balancer_ip]` attribute accepts an explicit ip
address or one in CIDR notation.

## SSL CA for MySQL Database

You can use a SSL CA key to connect to a MySQL Database server by adding
the `sslca` key to the authenticator and database databags.

```bash
  "sslca" : "/path/to/sslca"
```

## Development

Development requires [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://vagrantup.com).

**Currently supports Vagrant 1.3.x and VirtualBox 4.2.x**

Get up and running quickly by following these steps.

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

## Testing

To run Spec tests:
```bash
bundle exec strainer test
```

To run Integration tests with Kitchen-CI
```bash
kitchen test default-ubuntu-1204
```
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
