locals {
  worker_servers = 1
  app_servers    = 1

  zone_id = ""
  domain  = var.domain_name
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
