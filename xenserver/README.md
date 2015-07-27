# Host Parameters

The templates use some Host Parameters to contol the flow of the template. These are:

* primary-disk: Disk to use for xenserver installtion defaults to sda
* gueststorage: If guest storage should be configred on primary-disk. Accepts yes or no
* source-type: Which type of source to use to locate installtion files. Accepts url, nfs and local.
* source-path: Address of installtion files. Example: http://[user[:passwd]]@host[:port]/path

More Information are available at end of this [presentation](cdn.ws.citrix.com/wp-content/uploads/2013/08/XenServer_unattended_installation_v10.pdf).
