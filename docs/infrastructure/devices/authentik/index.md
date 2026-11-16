# Authentik

Authentik is the system we use to provide single sign-on and administration of users within the Hackspace.

[https://id.leighhack.org/](https://id.leighhack.org)

It's the front door for everything in [Internal Services](../../internal_services.md), and
it's also where your account lives for logging into the Pi Room machines and the servers.
The `Members` group (put there by a nightly sync from your GoCardless membership) is what
the [tailnet](../../vpn.md) and the member-facing services check; `Infra` is what gets you
into the administrative ones.

## Where It Runs

Containers on `services1` - server, worker, Postgres, Redis, and the RADIUS and LDAP
outposts, all under podman, all managed by the infra repo. That moved here from a dedicated
appliance VM on 2026-10-28.

`authentik.int.leighhack.org` and `10.3.1.36` are answered by that box, and **`10.3.1.36`
is a second address on services1, not a machine**. It was kept as an address rather than
moved because the ProCurve switches have `radius-server host 10.3.1.36` in NVRAM and the
LDAP clients point at the name; both groups are unreconfigurable. The old VM (`108` on
Proxmox) is stopped, has `onboot` cleared, and must stay that way - it still has the live
DHCP reservation for that address, so starting it means two hosts answering one address.

Two things that are load-bearing and must not be "tidied up":

* **`AUTHENTIK_SECRET_KEY` is unrotatable.** The database we migrated was sealed with it
  and Authentik cannot re-encrypt what it has already written. Rotating it locks the
  installation.
* **The outpost tokens** (RADIUS and LDAP) live in the database and came across with it.
  Same argument.

## What It's Wired Into

* OIDC for our own apps (Grafana, Filestore, switch-gui, the membership dashboard, and the
  rest), always authorization-code with **S256 PKCE** and an `Infra`/`Members` group check
* The [tailnet](../../vpn.md) - devices sign in with Authentik and only the `Members` group
  is allowed
* RADIUS for the network switches, and LDAP/S for the Pi Room and anything else that wants
  a directory. Note the switches don't actually authenticate over RADIUS yet - see
  [Network Switches](../network_switches/index.md#logging-in)
* Unix accounts on the NixOS boxes: your uid is `2000 +` your Authentik user id, and that
  number is the ACL on your NAS home directory. It is derived, not stored, so **don't
  delete and re-create a user** to fix something

## Admin Tasks

### Reset a user's password

* Login to Authentik as a Administrator
* Click on the "Admin interface" button in the top right
* On the left menu, expand 'Directory' and select 'Users'
* Select the user required
* Click 'Reset password' and follow the form guide.

### Disable a user

Disabling a user will immediately stop them accessing most services, and also restrict access via the door system.

* Login to Authentik as a Administrator
* Click on the "Admin interface" button in the top right
* On the left menu, expand 'Directory' and select 'Users'
* Select the user required
* Click 'Edit', untick the 'Is Active' field, and click Save.

### Add or remove someone from Infra

Same route, 'Groups' instead of 'Users', then `Infra` → Members. This takes effect on a
login rather than instantly: a session that's already signed in keeps whatever groups it was
issued with until it re-authenticates.

### Create an OIDC app

**Read `docs/authentik-oidc-notes.md` in the infra repo first.** It has the provider table
and three things that each cost someone a session: copy the flows and `signing_key` from a
known-good provider rather than making new ones, duration fields must be `key=value`
(`minutes=5`, never `5m` - `5m` saves fine and then 500s at the authorize endpoint), and a
custom scope needs a real ScopeMapping child row, because a plain PropertyMapping is
silently ignored.

Client secrets are write-only in the UI but **readable through the ORM**, so never dump a
whole provider object into a terminal, a log, or a screenshot.

### Scripting against it

The admin REST API can't be used from the box it runs on - nginx routes
`/api/v3/...` collection endpoints to the UI SPA, so they answer 404 with HTML. Use the
ORM shell instead:

```bash
sudo podman exec -it authentik-server ak shell
```

Real admins are in the `Infra` group. The old `akadmin` account is disabled.
