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
  description = "Private DNS Zone name"
  type        = string
}

variable "private_dns_zone_vnet_ids" {
  description = "IDs of the VNets to link to the Private DNS Zone"
  type        = list(string)
}

variable "is_not_private_link_service" {
  description = "Boolean to determine if this module is used for Private Link Service or not"
  type        = bool
  default     = true
}

variable "registration_enabled" {
  description = "Is auto-registration of VM records in the VNet in the Private DNS zone enabled? Defaults to `false`."
  type        = bool
  default     = false
}
