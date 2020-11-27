resource "cloudflare_record" "workers" {
  type    = "A"
  name    = "${random_pet.workers[count.index].id}.paas"
  zone_id = local.zone_id
  value   = linode_instance.workers[count.index].ip_address
  proxied = false

  count = local.worker_servers
}

resource "cloudflare_record" "apps" {
  type    = "A"
  name    = "${random_pet.apps[count.index].id}.paas"
  zone_id = local.zone_id
  value   = linode_instance.apps[count.index].ip_address
  proxied = true

  count = local.app_servers
}
