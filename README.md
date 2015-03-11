# Shared Puppet module for server and Vagrant provisioning

The Puppet module `malmo-mcommons` contains shared configurations for standalone (no master) Puppet provisioning of servers and Vagrants at City of Malmö. It is used for a one-time provisioning on a fresh Ubuntun 14.04 server or Vagrant box. The projects repo has two inititiation Puppet files, `server.pp` and `vagrant.pp` in the `puppet/` directory as well as a bootstrap script. The `Vagrant` file is in the root directory of the project using this module.

For usage, see the documentation for [Server Setup](https://github.com/malmostad/sitesearch#server-setup), [Development Setup](https://github.com/malmostad/sitesearch#development-setup) and the files in the [sitesearch/puppet](https://github.com/malmostad/sitesearch/tree/master/puppet) directory.

## License
Released under AGPL version 3.
