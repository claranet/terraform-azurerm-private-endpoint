module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  cidrs = ["192.168.1.0/24"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = true

  cidrs = ["192.168.1.128/25"]
}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  admin_objects_ids = [data.azurerm_client_config.current.object_id]

  logs_destinations_ids = [
    module.logs.storage_account_id,
    module.logs.id,
  ]
}

module "kv_private_dns_zone" {
  source  = "claranet/private-endpoint/azurerm//modules/private-dns-zone"
  version = "x.x.x"

  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name                = "privatelink.vaultcore.azure.net"
  virtual_network_ids = [module.vnet.id]
}

module "kv_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  subnet_id        = module.subnet.id
  target_resource  = module.key_vault.id
  subresource_name = "vault"

  use_existing_private_dns_zones = true
  private_dns_zones_ids          = [module.kv_private_dns_zone.id]
}
