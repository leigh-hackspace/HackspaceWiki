# VPN

Leigh Hackspace offers a VPN service to its members, this allows you connect to hackspace internal services while outside of the space itself. 

We currently use OpenVPN, so on Windows, Linux, Android, and iOS you can use the native packages, and on macOS we suggest [Viscosity](https://www.sparklabs.com/viscosity/).

## Requirements

You'll need an account on [id.leighhack.org](https://id.leighhack.org). Ideally, sign up with the same email address that you used for your GoCardless membership and privileges will be automatically assigned. If not, then contact [Infra](../membership/useful_contacts.md#tech-infrastructure).

## Configuration

These config files should enable you to configure and connect with a click of a button:

* [VPN Configuration](vpn/members-vpn.ovpn)
* [VPN Configuration for older OpenVPN versions](vpn/members-vpn-old.ovpn)

## MacOS

[Viscosity](https://www.sparklabs.com/viscosity/) is the suggested OpenVPN client for MacOS, its simplifies the configuration and works without any issues. Install, and double click the above OVPN file to install the profile, then select the profile via the menubar item for Viscosity.

### Linux, GNOME, and Network Manager

GNOME and Network Manager are commonly used on Ubuntu, Debian, and EL distributions (RHEL, CentOS, Fedora).

1. Open GNOME Settings, and browse to 'Network'
2. Click '+' in the VPN section and select 'Import from file...'
3. Select the VPN configuration file from the link above.
4. You'll be presented with a completed configuration, goto the 'IPv4' tab and tick on 'Use this connection only for resources on its network'
5. Repeat the same again for the 'IPv6' tab.
6. Click 'Save'

You can now test the connection, by default it'll attempt to connect to your current username and will prompt you for a password, this will be what its setup on Authentik.

## Access

This VPN will give you access the same as being on the WiFi within the hackspace. If you have any specific requirements you need from the VPN then contact [Infra](../membership/useful_contacts.md#tech-infrastructure).