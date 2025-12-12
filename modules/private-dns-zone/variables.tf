variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "name" {
  description = "Private DNS Zone name."
  type        = string
}

variable "virtual_network_ids" {
  description = "IDs of the Virtual Networks to link to the Private DNS Zone."
  type        = list(string)
}

variable "is_not_private_link_service" {
  description = "Boolean to determine if this module is used for Private Link Service or not."
  type        = bool
  default     = true
}

variable "vm_autoregistration_enabled" {
  description = "Is auto-registration of VM records in the VNet in the Private DNS zone enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "internet_fallback_enabled" {
  description = "Whether to enable internet fallback for the Private DNS Zone."
  type        = bool
  default     = false
}
