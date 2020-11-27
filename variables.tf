variable "linode_image_id" {
  description = "Image ID for the base image used for VMs"

  validation {
    condition = (
      length(var.linode_image_id) > 8 &&
      substr(var.linode_image_id, 0, 8) == "private/"
    )
    error_message = "The image id must start with \"private/\"."
  }
}

variable "domain_name" {
  description = "Secondary-level domain name (e.g., \"example.com\")."

  validation {
    condition = (
      length(split(".", var.domain_name)) > 1 &&
      !contains(split(".", var.domain_name), "")
    )
    error_message = "Choose a domain name that includes both the TLD (\".com\") and secondary-level name (\"example\")."
  }
}
