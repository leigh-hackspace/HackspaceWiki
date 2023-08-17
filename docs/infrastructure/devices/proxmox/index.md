# Proxmox Clusters

Currently we have one operational Proxmox cluster, 'monster', which has enough CPU and Memory for anything we'll need in the hackspace.

## Admin Tasks

### Allowing users access to the Cluster

* Login to https://monster.int.leighhack.org/ as a Infra member.
* Click on 'Datacenter (monster)' in the left menu.
* Goto Users and find the user that requires access.
* Either add them to the 'Infra', or 'Members' group as needed.

### Login without using id.leighhack.org/Authentik

* Go to https://monster.int.leighhack.org/
* On the login screen, select the dropdown and pick 'Linux PAM'
* Username is 'root', password is in the password manager.