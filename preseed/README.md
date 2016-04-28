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

* `install-disk`: What device to install to (default: the first disk returned with `list-devices disk`)
* `partitioning-method`: `regular` (default for `Preseed default`), `lvm` (default for `Preseed default lvm`) or `crypto`
* `partitioning-recipe`: `atomic` (default for `Preseed default`), `home`, or `multi` (default for `Preseed default lvm`)
* `partitioning-expert-recipe`: Entire recipe (default: empty, i.e `partitioning-recipe`)
* `partitioning-vg-name`: LVM volume group name (default: `vg01` for `Preseed default lvm`)
* `partitioning-filesystem`: One of `ext4`, `ext4`, `btrfs`, ... (default: empty, the default is used)
* `enable-puppetlabs-repo`: Add the Puppet Labs APT repo to the APT sources during install (default: `false`)
* `enable-puppetlabs-pc1-repo`: Add the Puppet Labs PC1 APT repo to the APT sources during install (default: `false`)
* `enable-saltstack-repo`: Add the SaltStack APT repo to the APT sources during install (default: `false`)
* `salt_master`: SaltStack Master (default: empty)
* `salt_grains`: Salt client specific information, like facter (default: empty)

Detailed description is available at https://www.debian.org/releases/stable/amd64/apbs04.html.en
