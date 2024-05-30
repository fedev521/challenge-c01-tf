resource "random_password" "cluster_token" {
  length  = 24
  special = false
}

locals {
  servers = [for i in range(var.k3s_server_count) : "server-${i + 1}"]
  agents  = [for i in range(var.k3s_agent_count) : "agent-${i + 1}"]
  nodes = {
    for nodeid in concat(local.servers, local.agents) : nodeid => {
      role     = split("-", nodeid)[0]
      hostname = nodeid
    }
  }

  k3s_config = templatefile("${path.module}/config/k3s-config.yaml.tftpl", {
    "pod_cidr"       = var.pod_cidr
    "service_cidr"   = var.service_cidr
    "cluster_dns_ip" = var.cluster_dns_ip
    "node_labels"    = []
  })

  cloud_init = {
    for nodeid, node in local.nodes : nodeid => templatefile("${path.module}/config/cloud_init.cfg", {
      "hostname"            = node.hostname
      "k3s_config"          = local.k3s_config
      "ssh_authorized_keys" = [for p in var.ssh_authorized_keys_paths : chomp(file(p))]
    })
  }
}
