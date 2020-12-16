resource "linode_instance" "workers" {
  label           = random_pet.workers[count.index].id
  image           = var.linode_image_id
  type            = "g6-nanode-1"
  tags            = ["bot-server", "terraform", "legacy"]
  region          = "us-east"
  private_ip      = true
  backups_enabled = false

  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 1000
    network_out    = 1000
    transfer_quota = 80
  }

  timeouts {
    create = "20m"
    update = "5m"
  }

  count = local.worker_servers
}

resource "linode_rdns" "workers" {
  address = linode_instance.workers[count.index].ip_address
  rdns    = "${linode_instance.workers[count.index].label}.paas.${local.domain}"

  count = local.worker_servers
}
