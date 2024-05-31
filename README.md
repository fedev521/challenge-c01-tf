# Challenge C01 - Terraform

This repo contains a **Terraform** configuration that creates VMs with
**libvirt** and installs and configures **k3s** to create a working Kubernetes
cluster in a matter of seconds.

- [1. Quick Start (TL;DR)](#1-quick-start-tldr)
- [2. Repository Structure](#2-repository-structure)
- [3. How To Use](#3-how-to-use)
  - [3.1. Create the Cluster](#31-create-the-cluster)
  - [3.2. Get kubeconfig](#32-get-kubeconfig)
  - [3.3. Basic Test](#33-basic-test)
- [4. How Does It Work](#4-how-does-it-work)
- [5. Useful Resources](#5-useful-resources)

## 1. Quick Start (TL;DR)

Requirements:

- terraform
- libvirt

```bash
sudo terraform init
sudo terraform apply
```

This way, you create a single-node Kubernetes cluster with k3s.

## 2. Repository Structure

The code organization is very close to a "standard" Terraform module, but I
split main.tf in two separate files:

- [libvirt.tf](./libvirt.tf)
- [k3s.tf](./libvirt.tf)

The `config/` folder contains Terraform file templates used to configure VMs and
k3s.

## 3. How To Use

### 3.1. Create the Cluster

Before creating the cluster, it is highly recommended to set proper values for
the following variables:

- `libvirt_uri`
- `ssh_authorized_keys_paths`

You can also tweak other important settings, such CPUs, RAM and disk sizes or
pod and services CIDR ranges. You can find information about module's variables
and outputs in [this file](./docs/terraform-docs.md).

You can create a single-node server setup (default) or a highly available
architecture by setting the `k3s_server_count` and `k3s_agent_count` variables.
Refer to the [k3s official documentation](https://docs.k3s.io/architecture) for
more information.

To create the cluster:

```bash
terraform init
terraform apply
```

Note: I tested only with `ubuntu-22.04-server-cloudimg` OS.

### 3.2. Get kubeconfig

To get kubeconfig to access the cluster via `kubectl`:

```bash
./scripts/get-kubeconfig.sh

# option 1: ephemeral
export KUBECONFIG="$PWD/k3s-kubeconfig"

# option 2: permanent
export KUBECONFIG="${KUBECONFIG:-~/.kube/config}:$PWD/k3s-kubeconfig"
kubectl config view --merge --flatten > ~/.kube/config-merged && mv ~/.kube/config-merged ~/.kube/config
```

### 3.3. Basic Test

Deploy and call a sample application:

```bash
kubectl apply -f sample-app/
kubectl get pods -n k3s-test -o wide

ip=$(terraform output -raw 'k3s_master_ip')
curl "http://$ip/test"
```

## 4. How Does It Work

The general working principle is the following:

1. `libvirt` creates VMs
2. terraform uses the templates in `config/` to create cloud-init and k3s
   configuration files
3. cloud-init initializes the VM
   1. creates the `/etc/rancher/k3s/config.yaml` configuration file
   2. starts the `k3s` service
4. thanks to the proper configuration, k3s forms a working Kubernetes cluster

## 5. Useful Resources

- [libvirt terraform provider](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs)
- [k3s doc](https://docs.k3s.io/)
- [cloud-init examples](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)
