# Puppet module for server and Vagrant provisioning

`malmo-mcommons` is an opinionated [Puppet](https://puppetlabs.com/) module that contains common configurations we use for provisioning of servers and [Vagrants](https://www.vagrantup.com/). Puppet is used in a standalone mode without a master. Ubuntu 14.04 is the target system.

The exact selection of system components to install for a specific application is defined in each projects `puppet/server.pp` and `puppet/vagrant.pp` files. See e.g. the [Sitesearch](https://github.com/malmostad/sitesearch) and [wp-apps](https://github.com/malmostad/wp-apps) repos.

Each repo that are using `malmo-mcommons` have all the instructions you need to be able to use the provisioning tool. The information below is for those who are about to configure a projects use of the module.


## The internals
The `malmo-mcommons` module uses several third-party Puppet modules listed in `/metadata.json`. Each applications configuration in it's own `/puppet/` directory contains calls to definitions in `malmo-mcommons`. The applications Puppet definitions should be minimal.

The provisioning of a server works like this:

The `/bootstrap.sh` script downloaded from this repo is executed on the server. It sets up Puppet and initiate the `server.pp` file that you download from the applications `/puppet/` repo. Both files must be in the same directory on the server.

The provisioning of a Vagrant box for development and testing on your own machine is similar:

Clone the repository for the application you are working with to your own machine. Run `vagrant up` in the applications project root. It creates an Ubuntu 14.04 Vagrant box and starts the provisioning using `bootstrap.sh` and the projects `puppet/vagrant.pp` file. Those are called from the `Vagrantfile` in  the project. You need to have Vagrant and VirtualBox or VMWare on your own machine.


## License
Released under AGPL version 3.
