data "azurecaf_name" "private_endpoint" {
  resource_type = "azurerm_private_endpoint"

  name     = var.stack
  use_slug = true
  prefixes = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
}

data "azurecaf_name" "private_dns_zone_group" {
  resource_type = "azurerm_private_dns_zone_group"

  name     = var.stack
  use_slug = true
  prefixes = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
}

data "azurecaf_name" "private_service_connection" {
  resource_type = "azurerm_private_service_connection"

  name     = var.stack
  use_slug = true
  prefixes = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
}
