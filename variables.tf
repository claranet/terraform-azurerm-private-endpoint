variable "location" {
  description = "Azure location"
  type        = string
}

variable "location_cli" {
  description = "CLI format for Azure location"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location"
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

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

#
# Private endpoint
#

variable "subnet_id" {
  description = "ID of the subnet in which the private endpoint will be created"
  type        = string
}

variable "resource_id" {
  description = "ID of the target resource"
  type        = string
}

variable "subresource_name" {
  description = "Name of the subresource corresponding to the target Azure resource, useful when the subresource cannot be determined automatically, e.g. for Azure services such as Azure Storage, Azure Cosmos DB, etc."
  type        = string
  default     = ""
}

#
# Private DNS zone
#

variable "create_private_dns_zone" {
  description = "Boolean to create the private DNS zone corresponding to the private endpoint. If you wish to centralize the DNS zone in another RG that could belong to another subscription, leave this option at `false` and use the 'private-dns-zone' submodule directly."
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone in which a new record will be created for the private endpoint, no private DNS zone group will be created if not set and `create_private_dns_zone = false`. When `private_dns_zone_id` is set and `create_private_dns_zone = true`, the ID of the private DNS zone created as part of the module overrides `private_dns_zone_id`."
  type        = string
  default     = ""
}

variable "private_dns_zone_vnet_ids" {
  description = "IDs of the VNets to link to the private DNS zone"
  type        = list(string)
  default     = []
}
