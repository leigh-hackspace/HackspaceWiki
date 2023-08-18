# QNAP NAS

The hackspace has a [QNAP TS-431+](https://www.qnap.com/en-uk/product/ts-431) which is used for general file storage, and a NFS backend for the [Proxmox clusters](../proxmox/index.md).

Currently the NAS has the following services on it:

* NFS

Samba/CIFS has been disabled as it doesn't work correctly with the LDAP server that Authentik provides. 

## Admin Tasks

### Check Health

* Login to the QNAP portal via [id.leighhack.org](https://id.leighhack.org), with a user in the 'Infra' group.
* Open the 'Disk Manager' application, check the health status in there.

### New File Share

* Login to the QNAP portal via [id.leighhack.org](https://id.leighhack.org), with a user in the 'Infra' group.
* Open the 'File Manager' application.
* Select the 'datastore' disk.
* Click the 'New Share' button.
* Fill in a name, leave the permissions as 'Admin' having access to it.
* Click OK and wait for the folder / share to be created.
* Goto the 'Settings' application
* Select 'Share Permissions'
* Select the share you created.
* In the combo box, switch to 'NFS permissions'
* Create the NFS permissions as needed.

ALL_SQUASH and ROOT_SQUASH have some weird side-effects after saving the settings, so go back and check that the values are correct after savings, sometimes they don't work.