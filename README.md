
# This Repository is archived and templates are migrated to the relevant repositories. For more information [Click Here](https://community.theforeman.org/t/heads-up-community-templates-repo-will-be-archived-tomorrow/19539).


# Community Templates

A place for us to collaborate around templates & snippets for various OSes.

# Repo metadata

So that the templates can eventually be updated automatically in Foreman, we are
adding metadata to the top of every template. This metadata can be read by a plugin
(such as [foreman_templates](https://github.com/theforeman/foreman_templates)) to
determine information abut the template. The metadata is read until the first non-comment
line, and contains, the template name, template kind, and any appropriate OS
associations. For example:

    #kind: user_data
    #name: My Userdata
    #oses:
    # - CentOS 7
    # - Debian
    # - Ubuntu

Because all the data is contained in the metadata, filenames are arbitrary, however,
for consistency we ask that they be grouped appropriately, and end in `.erb`.

Have a look around the repo for examples.

# Testing

There is a test suite available in this repo that tries to render templates
using dummy values passing the output to ksvalidator tool which can be found
in Fedora and Red Hat repositories as part of _pykickstart_ package and in
Ubuntu repositories as part of _python-pykickstart_ package.

You will need ksvalidator from Fedora 20 or later to execute tests.
Pykickstart can be installed from git easily too. Use '-l' option to get list
of supported versions:

    $ ksvalidator -l

To start unit tests do something like:

    $ ruby -Itest test/kickstart/provision_test.rb

Another set of tests is in Foreman core git repository, it's possible to run
useful render test from the core git repo against this directory:

    foreman$ bundle exec rake templates:render DIRECTORY=/path/to/community-templates/provisioning_templates/

It will render selected templates and output can be easily compared via `git diff`.

# Contributing

Please fork and send a pull request. Thanks!

# Notes for various templates

## CoreOS

The templates use some Host Parameters to contol the flow of the template. These are:

- install-disk: What device to install to (default: /dev/sda | /dev/vda)
- ssh_authorized_keys: add public SSH keys which will be authorized for the core user. You can specify multiple SSH keys seperated with a "," (default: empty)
- etcd_discovery_url: provision a discovery token for etcd to allow a simple cluster deployment. You can get a new discovery token at <https://discovery.etcd.io/new>. This parameter is used in the [coreos_cloudconfig snippet](https://github.com/theforeman/community-templates/blob/develop/snippets/coreos_cloudconfig.erb). (default: empty)
- expose_docker_socket: if you want to have an exposed Docker TCP socket set this to "true"
- enable_etcd: if you don't require the etcd (and fleet) service, set this to "false" (default: true)
- reboot-strategy: set the reboot-strategy for CoreOS, for more information have a look at the official [documentation](https://coreos.com/os/docs/latest/update-strategies.html)

If you don't add any SSH keys you can login with the core user using the root password.

More Information are available on the [CoreOS site](https://coreos.com/docs/cluster-management/setup/cloudinit-cloud-config)

## Kickstart

### Kickstart Files

There is one [kickstart](provisioning_templates/provision/kickstart_default.erb) and accompanying [PXE config](provisioning_templates/PXELinux/kickstart_default_pxelinux.erb),
which works for:

Fedora 16
Fedora 17
Fedora 18
Fedora 19
Fedora 20
RHEL, CentOS 5.9
RHEL, CentOS 6.3

## Poap

Cisco NX-OS PowerOn Auto Provisioning (POAP) support

More information is available here: http://projects.theforeman.org/issues/10526

## Preseed

Tested on:

* Ubuntu 10.04 (lucid)
* Ubuntu 12.04 (precise)
* Ubuntu 13.04 (raring)
* Ubuntu 14.04 (trusty)
* Debian 6.0 (Squeeze)
* Debian 7 (Wheezy)
* Debian 8 (Jessie)

### Host Parameters

The templates use some Host Parameters to control the flow of the template. These are:

* `install-disk`: What device to install to (default: the first disk returned with `list-devices disk`)
* `partitioning-method`: `regular` (default for `Preseed default`), `lvm` (default for `Preseed default lvm`) or `crypto`
* `partitioning-recipe`: `atomic` (default for `Preseed default`), `home`, or `multi` (default for `Preseed default lvm`)
* `partitioning-disk-label`: If present labels the disk as specified. (Default: automatic/not set. Can be `msdos` or `gpt`)
* `partitioning-expert-recipe`: Entire recipe (default: empty, i.e `partitioning-recipe`)
* `partitioning-vg-name`: LVM volume group name (default: `vg01` for `Preseed default lvm`)
* `partitioning-filesystem`: One of `ext4`, `ext4`, `btrfs`, ... (default: empty, the default is used)
* `partitioning-crypto-erase`: Secure erase partition when using crypto method. `true` or `false` (default: `false`)
* `partitioning-crypto-password`: Password for luks crypto method. Recommend changing this post install! (default: `temporarypassword`)
* `partitioning-crypto-password-weak`: Allow weak passwords when using crypto. (default: `false`)
* `partitioning-allow-noswap`: Allow partitioning without swap. (default: `false`)
* `enable-puppet-puppet5`: Assume Puppet 5 AIO packages instead of system packages
* `enable-puppet-puppet6`: Assume Puppet 6 AIO packages instead of system packages
* `enable-puppetlabs-repo`: Add the Puppet Labs repo during install (default: `false`)
* `enable-puppetlabs-puppet5-repo`: Add the Puppet Labs Puppet 5 repo during install (default: `false`)
* `enable-puppetlabs-puppet6-repo`: Add the Puppet Labs Puppet 6 repo during install (default: `false`)
* `enable-saltstack-repo`: Add the SaltStack APT repo to the APT sources during install (default: `false`)
* `salt_master`: SaltStack Master (default: empty)
* `salt_grains`: Salt client specific information, like facter (default: empty)
* `preseed-update-policy`: Preseed policy for applying updates to running systems. Can be `none`, `unattended-upgrades`, or `landscape`. (default: unattended-upgrades)
* `preseed-live-installer`: Informs the installer that the installation source is from an iso. Can be `true` or `false`. (defaults: notset/false)
* `preseed-kernel-image`: Specify the kernel-image to install. Ex: `linux-image-generic-lts-xenial` or `linux-image-4.4.0-34-generic`. (default: empty)
* `preseed-post-install-upgrade`: Upgrade Debian post installation. Can be `none`, `safe-upgrade`, or `full-upgrade`. (default: none)

Detailed description is available at https://www.debian.org/releases/stable/amd64/apbs04.html.en

## ZTP

Junos Zero-Touch-Provisioning support

More information is available here: http://projects.theforeman.org/issues/3906

# License

Copyrights are retained by their owners

This entire repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Exceptions

The following file(s) are not licensed under the GPLv3+ as described above and
instead contain copyright and license information in their headers:

* ztp/provision.erb: BSD 2-clause licensed
