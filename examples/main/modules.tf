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

locals {
  vnets = [
    {
      name_suffix = "001"
      cidr_list   = ["172.16.0.0/16"]
    },
    {
      name_suffix = "002"
      cidr_list   = ["192.168.1.0/24"]
    },
  ]
}

module "vnets" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  for_each = { for vnet in local.vnets : vnet.name_suffix => vnet }

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = each.key
  vnet_cidr   = each.value.cidr_list
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  virtual_network_name = module.vnets["001"].virtual_network_name

  enforce_private_link = true
  subnet_cidr_list     = ["172.16.4.0/24"]
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

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]

  admin_objects_ids = [
    data.azurerm_client_config.current.object_id
  ]
}

module "private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_cli        = module.region.location_cli
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  resource_id = module.key_vault.key_vault_id
  subnet_id   = module.subnet.subnet_id

  create_private_dns_zone = true

  private_dns_zone_vnet_ids = [
    module.vnets["001"].virtual_network_id,
    module.vnets["002"].virtual_network_id,
  ]
}
