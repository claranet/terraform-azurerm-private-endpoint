module "region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "vnet_01" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "01"

  vnet_cidr = ["192.168.1.0/24"]
}

module "subnet_01" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "01"

  virtual_network_name = module.vnet_01.virtual_network_name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = true

  subnet_cidr_list = ["192.168.1.128/25"]
}

module "vnet_02" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "02"

  vnet_cidr = ["172.16.0.0/16"]
}

module "subnet_02" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "02"

  virtual_network_name = module.vnet_02.virtual_network_name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = true

  subnet_cidr_list = ["172.16.4.0/24"]
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  admin_objects_ids = [data.azurerm_client_config.current.object_id]

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]
}

module "lb" {
  source  = "claranet/lb/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  allocate_public_ip = true
}

resource "azurerm_private_link_service" "example" {
  name     = "pls-${var.stack}-${var.client_name}-${module.region.location_short}-${var.environment}"
  location = module.region.location

  resource_group_name = module.rg.resource_group_name

  load_balancer_frontend_ip_configuration_ids = [module.lb.frontend_ip_configuration[0].id]

  nat_ip_configuration {
    name      = "default"
    primary   = true
    subnet_id = module.subnet_02.subnet_id
  }
}

module "kv_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "kv"

  subnet_id        = module.subnet_01.subnet_id
  target_resource  = module.key_vault.key_vault_id
  subresource_name = "vault"

  private_dns_zones_names     = ["privatelink.vaultcore.azure.net"]
  private_dns_zones_vnets_ids = [module.vnet_01.virtual_network_id, module.vnet_02.virtual_network_id]
}

module "example_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "example"

  subnet_id       = module.subnet_02.subnet_id
  target_resource = azurerm_private_link_service.example.id
}

module "example_alias_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.region.location
  location_short = module.region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "examplealias"

  is_manual_connection = true

  subnet_id       = module.subnet_02.subnet_id
  target_resource = azurerm_private_link_service.example.alias
}
