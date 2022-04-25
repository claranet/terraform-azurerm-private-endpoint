variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone name"
  type        = string
}

variable "private_dns_zone_vnet_ids" {
  description = "IDs of the VNets to link to the private DNS zone"
  type        = list(string)
}
