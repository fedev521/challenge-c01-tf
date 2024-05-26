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
  count = var.node_count

  name           = "node-${count.index + 1}.qcow2"
  size           = var.disk_size_gb * 1000 * 1000 * 1000
  pool           = libvirt_volume.os.pool
  base_volume_id = libvirt_volume.os.id
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = var.node_count

  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_volume.main_disk[count.index].pool
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

    # (Optional) one or more DNS host entries.  Both of
    # "ip" and "hostname" must be specified.  The format is:
    # hosts  {
    #     hostname = "my_hostname"
    #     ip = "my.ip.address.1"
    #   }
  }
}

resource "libvirt_domain" "node" {
  count = var.node_count

  name   = "kube-node-${count.index + 1}"
  memory = var.ram_mb
  vcpu   = var.vcpus

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  disk {
    volume_id = libvirt_volume.main_disk[count.index].id
  }

  network_interface {
    network_id     = libvirt_network.kubenetwork.id
    hostname       = "node-${count.index + 1}"
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
