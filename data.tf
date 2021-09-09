locals {
  worker_servers = 1
  app_servers    = 1

  zone_id = data.cloudflare_zones.base.zones[0].id
  domain  = data.cloudflare_zones.base.zones[0].name
}

resource "random_pet" "workers" {
  length = 2
  separator = "-"

  count = local.worker_servers
}

resource "random_pet" "apps" {
  length = 2
  separator = "-"

  count = local.app_servers
}

data "cloudflare_zones" "base" {
  filter {
    name = var.domain_name
  }
}
