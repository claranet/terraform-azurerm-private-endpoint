module "region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  location    = module.region.location
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  vnet_cidr = ["192.168.1.0/24"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["192.168.1.128/25"]

  private_link_endpoint_enabled = true
  private_link_service_enabled  = true
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  admin_objects_ids = [data.azurerm_client_config.current.object_id]

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]
}

module "kv_private_dns_zone" {
  source  = "claranet/private-endpoint/azurerm//modules/private-dns-zone"
  version = "x.x.x"

  environment         = var.environment
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  private_dns_zone_name     = "privatelink.vaultcore.azure.net"
  private_dns_zone_vnet_ids = [module.vnet.virtual_network_id]
}

module "kv_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  subnet_id        = module.subnet.subnet_id
  target_resource  = module.key_vault.key_vault_id
  subresource_name = "vault"

  use_existing_private_dns_zones = true
  private_dns_zone_ids           = [module.kv_private_dns_zone.private_dns_zone_id]
}
