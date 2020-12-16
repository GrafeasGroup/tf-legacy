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

  connection {
    type        = "ssh"
    host        = self.ip_address
    user        = var.ssh_username
    port        = var.ssh_port
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    destination = "/tmp/first-run.sh"
    content     = <<-EOF
    #!/usr/bin/env bash
    set -euo pipefail

    exec >/var/log/first-run.log 2>&1

    ${templatefile("${path.module}/scripts/hostname.sh", { hostname = self.label, domain = "paas.${local.domain}" })}
    printf '>>>  DONE\n'
    EOF
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/first-run.sh",
      "sudo /tmp/first-run.sh",
      "sudo rm -f /tmp/first-run.sh",
    ]
  }

  count = local.worker_servers
}

resource "linode_rdns" "workers" {
  address = linode_instance.workers[count.index].ip_address
  rdns    = "${linode_instance.workers[count.index].label}.paas.${local.domain}"

  count = local.worker_servers
}
