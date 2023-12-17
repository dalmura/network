variable "site_name" {
  type = string
}

variable "site_dydns" {
  type = string
}

variable "management_devices" {
  type        = map(string)
  description = "IP Address => Hostname"
}

variable "cloud_entries" {
  type        = map(string)
  description = "Hostname => IP Address"
}

locals {
  site_device_prefix = "dal-${var.site_name}-"
}
