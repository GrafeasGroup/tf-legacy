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

    dnf update -y

    ${templatefile("${path.module}/scripts/hostname.sh", { hostname = self.label, domain = "paas.${local.domain}" })}
    printf '>>>  DONE\n'
    EOF
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/first-run.sh",
      "sudo rm -f /tmp/first-run.sh",
    ]
  }

  count = local.app_servers
}
