provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_pool" "kubestorage" {
  name = "kubestorage"
  type = "dir"
  path = "/tmp/libvirt-pool-kubestorage"
}

resource "libvirt_volume" "os" {
  name   = "base-os.qcow2"
  pool   = libvirt_pool.kubestorage.name
  source = var.os
  format = "qcow2"
}

resource "libvirt_volume" "main_disk" {
  for_each = local.nodes

  name           = "vol-${each.key}.qcow2"
  size           = var.disk_size_gb * 1000 * 1000 * 1000
  pool           = libvirt_volume.os.pool
  base_volume_id = libvirt_volume.os.id
}

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = local.nodes

  name = "commoninit.iso"
  pool = libvirt_volume.main_disk[each.key].pool

  user_data      = local.cloud_init[each.key]
  network_config = templatefile("${path.module}/config/network_config.cfg", {})
}

resource "libvirt_network" "kubenetwork" {
  name      = "k8snet"
  mode      = "nat"
  domain    = "k8s.local"
  addresses = ["10.17.3.0/24"]

  dns {
    # (Optional, default false)
    # Set to true, if no other option is specified and you still want to 
    # enable dns.
    enabled = true

    # (Optional, default false)
    # true: DNS requests under this domain will only be resolved by the
    # virtual network's own DNS server
    # false: Unresolved requests will be forwarded to the host's
    # upstream DNS server if the virtual network's DNS server does not
    # have an answer.
    local_only = true
  }
}

locals {
  master_ip = "10.17.3.3"
}

resource "libvirt_domain" "node" {
  for_each = local.nodes

  name   = "kube-${each.key}"
  memory = var.ram_mb
  vcpu   = var.vcpus

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id

  disk {
    volume_id = libvirt_volume.main_disk[each.key].id
  }

  network_interface {
    network_id     = libvirt_network.kubenetwork.id
    hostname       = each.value.hostname
    addresses      = each.key == "server-1" ? [local.master_ip] : null
    wait_for_lease = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
