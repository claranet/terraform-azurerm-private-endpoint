# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. Custom names override this if set. Legacy default names is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_private_endpoint_name" {
  type        = string
  description = "Custom Private Endpoint name, generated if not set."
  default     = ""
}

variable "custom_private_dns_zone_group_name" {
  type        = string
  description = "Custom Private DNS Zone Group name, generated if not set."
  default     = ""
}

variable "custom_private_service_connection_name" {
  type        = string
  description = "Custom Private Service Connection name, generated if not set."
  default     = ""
}
