# Kubernetes Lab

## Cluster Features

### Installed and working

* OIDC single sign-on with `id.leighhack.org` (see [Authentication](#authentication))
* NFS-backed PVs - works well for all applications bar ones that use SQLite.

### Coming Soon

* MetalLB-based `LoadBalancer` Service types.
* Traefik-based `Ingress` support with mapping to `*.lab.leighhack.org`

## Permissions

By default, all members should have read permissions to the entire cluster. `Infra` members are cluster admins. 

Per-member namespaces with write access can be created via this repository (see [nikdoof namespace](https://github.com/leigh-hackspace/k8s-lab/tree/main/clusters/lab/members/nikdoof) for an example).

## Authentication

We use OIDC to authenticate via `id.leighhack.org`

### 1. Download `kubectl` and your preferred clients

`kubectl` is the basic tool needed to connect to Kubernetes clusters. The lab cluster is currently running v1.27, so make sure you download that version.

[Install tools](https://kubernetes.io/docs/tasks/tools/)

### 2. Download and install `kubelogin`

[Kubelogin](https://github.com/int128/kubelogin) is a tool to help you login easily with a OIDC based Kubernetes cluster. To install it download the latest release and place it in your `PATH` named `kubectl-odic_login`. Now you can run `kubectl oidc-login` and be prompted with a setup message. You don't need to complete the setup (we've done the hard work for you!)

### 3. Set up the kubeconfig

Here is a `kubeconfig` file you can use to connect to the lab cluster. Place this in `~/.kube/config` and it'll "just work".

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJUXlvU05adTdsNll3RFFZSktvWklodmNOQVFFTEJRQ$
    server: https://k8s-lab.int.leighhack.org:6443
  name: leighhack-lab
contexts:
- context:
    cluster: leighhack-lab
    user: leighhack-oidc
  name: leighhack-lab
current-context: leighhack-lab
kind: Config
preferences: {}
users:
- name: leighhack-oidc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=https://id.leighhack.org/application/o/kubernetes-lab/
      - --oidc-client-id=kubernetes-lab
      - --oidc-extra-scope=email
      - --oidc-extra-scope=openid
      - --oidc-extra-scope=profile
      command: kubectl
      env: null
      provideClusterInfo: false
```

### 4. Test your connection

Running `kubectl get pods -A` should redirect you to `id.leighhack.org` to login, once logged in it should complete the command and show you all pods running on the cluster.