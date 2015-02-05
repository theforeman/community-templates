# Templates

Tested on:

* Ubuntu 10.04 (lucid)
* Ubuntu 12.04 (precise)
* Ubuntu 13.04 (raring)
* Ubuntu 14.04 (trusty)
* Debian 6.0 (Squeeze)
* Debian 7 (Wheezy)
* Debian 8 (Jessie)

# Host Parameters

The templates use some Host Parameters to contol the flow of the template. These are:

* install-disk: What device to install to (default: /dev/sda | /dev/vda)
* enable-puppetlabs-repo: Add the Puppet Labs APT repo to the APT sources during install (default: no)
* enable-saltstack-repo: Add the SaltStack APT repo to the APT sources during install (default: no)
* salt_master: SaltStack Master (default: empty)
* salt_grains: Salt client specific information, like facter (default: empty)
