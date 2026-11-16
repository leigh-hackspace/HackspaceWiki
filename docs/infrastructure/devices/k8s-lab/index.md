# Kubernetes Lab (retired)

We ran a small lab cluster: three VMs on the Proxmox host (`k8s-lab-01` - `k8s-lab-03`,
`10.3.1.32` - `10.3.1.34`), Kubernetes v1.27, single sign-on through
[id.leighhack.org](https://id.leighhack.org), and NFS-backed persistent volumes. The plan
was MetalLB for `LoadBalancer` services and Traefik for `*.lab.leighhack.org`; that never
happened.

**It is not running, and hasn't been for a while.** The VMs are stopped on `monster1`
(their disks are still on the NAS), `k8s-lab.int.leighhack.org` no longer resolves, and
`10.3.1.32` is `aibox` now. This page is kept so the design isn't lost, not because
anything in it works.

The manifests and per-member namespace setup lived in
[leigh-hackspace/k8s-lab](https://github.com/leigh-hackspace/k8s-lab); the old `kubeconfig`
and kubelogin instructions are in the git history of this page.

If you want the cluster back, the honest starting point is "build a new one and delete
these VMs" - three 8 GB nodes is most of what the host has, and a 2023 v1.27 cluster has
no upgrade path anyone here has tested. Talk to [infra](../../../membership/useful_contacts.md#tech-infrastructure)
before claiming those addresses again.
