data "azurecaf_name" "private_endpoint" {
  name          = var.stack
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "pe"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "private_dns_zone_group" {
  name          = var.stack
  resource_type = "azurerm_private_dns_zone_group"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "pdnszg"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "private_service_connection" {
  name          = var.stack
  resource_type = "azurerm_private_service_connection"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "psc"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
