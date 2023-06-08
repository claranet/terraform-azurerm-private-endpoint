variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

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

variable "subnet_id" {
  description = "ID of the subnet in which the Private Endpoint will be created."
  type        = string
}

variable "ip_configurations" {
  description = <<EOD
List of IP Configuration object. Any modification to the parameters of the IP Configuration object forces a new resource to be created.
```
name               = Name of the IP Configuration.
member_name        = Member name of the IP Configuration. If it is not specified, it will use the value of `subresource_name`. Only valid if `target_resource` is not a Private Link Service.
subresource_name   = Subresource name of the IP Configuration. Only valid if `target_resource` is not a Private Link Service.
private_ip_address = Private IP address within the Subnet of the Private Endpoint.
```
EOD
  type = list(object({
    name               = optional(string, "default")
    member_name        = optional(string)
    subresource_name   = optional(string)
    private_ip_address = string
  }))
  default  = []
  nullable = false
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require manual approval from the remote resource owner? Default to `false`."
  type        = bool
  default     = false
}

variable "request_message" {
  description = "A message passed to the owner of the remote resource when the Private Endpoint attempts to establish the connection to the remote resource. Only valid if `is_manual_connection` is set to `true`."
  type        = string
  default     = "Private Endpoint Deployment"
}

variable "target_resource" {
  description = "Private Link Service Alias or ID of the target resource."
  type        = string

  validation {
    condition     = length(regexall("^([a-z0-9\\-]+)\\.([a-z0-9\\-]+)\\.([a-z]+)\\.(azure)\\.(privatelinkservice)$", var.target_resource)) == 1 || length(regexall("^\\/(subscriptions)\\/([a-z0-9\\-]+)\\/(resourceGroups)\\/([A-Za-z0-9\\-_]+)\\/(providers)\\/([A-Za-z\\.]+)\\/([A-Za-z]+)\\/([A-Za-z0-9\\-]+)$", var.target_resource)) == 1
    error_message = "The `target_resource` variable must be a Private Link Service Alias or a resource ID."
  }
}

variable "subresource_name" {
  description = "Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service."
  type        = string
  default     = ""
}

variable "use_existing_private_dns_zones" {
  description = "Boolean to create the Private DNS Zones corresponding to the Private Endpoint. If you wish to centralize the Private DNS Zones in another Resource Group that could belong to another subscription, set this option to `true` and use the `private-dns-zone` submodule directly."
  type        = bool
  default     = false
}

variable "private_dns_zones_ids" {
  description = "IDs of the Private DNS Zones in which a new record will be created for the Private Endpoint. Only valid if `use_existing_private_dns_zones` is set to `true` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_dns_zones_names" {
  description = "Names of the Private DNS Zones to create. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_dns_zones_vnets_ids" {
  description = "IDs of the VNets to link to the Private DNS Zones. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service."
  type        = list(string)
  default     = []
}
