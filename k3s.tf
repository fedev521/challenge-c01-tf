resource "random_password" "cluster_token" {
  length  = 24
  special = false
}

resource "random_password" "agent_token" {
  length  = 16
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

  k3s_config = {
    for nodeid, node in local.nodes : nodeid => templatefile("${path.module}/config/k3s-config.yaml.tftpl", {
      "node_labels"    = []
      "is_master"      = nodeid == "server-1"
      "is_server"      = node.role == "server"
      "is_agent"       = node.role == "agent"
      "k3s_url"        = "https://${local.master_ip}:6443"
      "cluster_token"  = random_password.cluster_token.result
      "agent_token"    = random_password.agent_token.result
      "pod_cidr"       = var.pod_cidr
      "service_cidr"   = var.service_cidr
      "cluster_dns_ip" = var.cluster_dns_ip
    })
  }

  cloud_init = {
    for nodeid, node in local.nodes : nodeid => templatefile("${path.module}/config/cloud_init.cfg", {
      "hostname"            = node.hostname
      "role"                = node.role
      "k3s_config"          = local.k3s_config[nodeid]
      "ssh_authorized_keys" = [for p in var.ssh_authorized_keys_paths : chomp(file(p))]
    })
  }
}
