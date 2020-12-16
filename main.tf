terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "grafeas"

    workspaces {
      prefix = "legacy-"
    }
  }

  required_version = ">= 0.13.5"

  required_providers {
    linode = {
      source  = "registry.terraform.io/linode/linode"
      version = "~> 1.12"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 2.3"
    }
    cloudflare = {
      source  = "registry.terraform.io/cloudflare/cloudflare"
      version = "~> 2.11"
    }
  }
}

provider "linode" {}
provider "random" {}
provider "cloudflare" {}
