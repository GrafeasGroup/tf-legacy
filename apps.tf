resource "linode_instance" "apps" {
  label           = random_pet.apps[count.index].id
  image           = var.linode_image_id
  type            = "g6-nanode-1"
  tags            = ["app-server", "terraform", "legacy"]
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

  count = local.app_servers
}

resource "linode_rdns" "apps" {
  address = linode_instance.apps[count.index].ip_address
  rdns    = "${linode_instance.apps[count.index].label}.paas.${local.domain}"

  count = local.app_servers
}
