# mcommons

`malmo-mcommons` is an opinionated [Puppet](https://puppetlabs.com/) module that contains common configurations we use for provisioning of servers and [Vagrants](https://www.vagrantup.com/). Puppet is used in standalone mode without a master. Ubuntu 14.04 is the target system.

The exact selection of system components to install for a specific application is defined in the applications `puppet/server.pp` and `puppet/vagrant.pp` files. See e.g. the [Sitesearch](https://github.com/malmostad/sitesearch) and [wp-apps](https://github.com/malmostad/wp-apps) repos.

Each repo that are using `mcommons` have the instructions you need to run the provisioning tool.


## The internals
The `mcommons` module uses several third-party Puppet modules listed in `metadata.json`. Applications using `mcommons` have a `puppet/` directory with two files, `vagrant.pp` and `server.pp`, using `mcommons` as a dependency. Each application's Puppet definitions should be minimal.

The provisioning of a server using `mcommons` works like this:

Download the `bootstrap.sh` script from this repo to the server along with the `server.pp` from the application's `puppet/` directory. They must be placed in the same directory on the server. When you execute the bootstrap script, it sets up Puppet and initiates `server.pp`. The latter downloads `mcommons` which in turn downloads the Puppet modules it needs.

The provisioning of a Vagrant box for development and testing shares most of it's configuration with the server. It works like this:

You need to have Vagrant and VirtualBox or VMWare on your own machine. Clone the repository for the application you are working with to your own machine. Run `vagrant up` in the applications root. It uses the `Vagrantfile` to create an Ubuntu 14.04 Vagrant instance and starts the provisioning using `bootstrap.sh` and the projects `puppet/vagrant.pp` file.


## License
Released under AGPL version 3.
