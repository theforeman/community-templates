# Junos Zero-Touch-Provisioning support

More information is available here: http://projects.theforeman.org/issues/3906

## Provisioning script

Due to BSD licensing, we're not currently shipping the SLAX provisioning script
that's required to complete support for ZTP.  Hopefully we can settle this soon
and provide it here.

In the meantime, this is available from:
https://github.com/fraenki/foreman/blob/6769123df/app/views/unattended/ztp/junos_ztp.slax.erb

It should be configured in Foreman with the template type "provision".
