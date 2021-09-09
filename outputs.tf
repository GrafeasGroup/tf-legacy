output "workers" {
  value = [
    for node in linode_instance.workers:
      {
        ipv4 = node.ip_address
        hostname = node.label
        domain = "${node.label}.paas.${local.domain}"
      }
  ]
}

output "apps" {
  value = [
    for node in linode_instance.apps:
      {
        ipv4 = node.ip_address
        hostname = node.label
        domain = "${node.label}.paas.${local.domain}"
      }
  ]
}
