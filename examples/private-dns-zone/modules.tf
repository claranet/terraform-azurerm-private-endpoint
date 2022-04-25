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
  resources = [
    {
      name_suffix      = "001"
      vnet_cidr_list   = ["172.16.0.0/16"]
      subnet_cidr_list = ["172.16.4.0/24"]
    },
    {
      name_suffix      = "002"
      vnet_cidr_list   = ["192.168.1.0/24"]
      subnet_cidr_list = ["192.168.1.128/25"]
    },
  ]
}

module "vnets" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  for_each = { for resource in local.resources : resource.name_suffix => resource }

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = each.key
  vnet_cidr   = each.value.vnet_cidr_list
}

module "subnets" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  for_each = { for resource in local.resources : resource.name_suffix => resource }

  client_name         = var.client_name
  environment         = var.environment
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix          = each.key
  virtual_network_name = module.vnets[each.key].virtual_network_name

  enforce_private_link = true
  subnet_cidr_list     = each.value.subnet_cidr_list
}

data "azurerm_client_config" "current" {}

module "key_vaults" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  for_each = { for resource in local.resources : resource.name_suffix => resource }

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  custom_name = "kv-test-demo-euw-${each.key}"

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]

  admin_objects_ids = [
    data.azurerm_client_config.current.object_id
  ]
}

module "private_dns_zone" {
  source  = "claranet/private-endpoint/azurerm//modules/private-dns-zone"
  version = "x.x.x"

  environment         = var.environment
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  private_dns_zone_name = "privatelink.vaultcore.azure.net"

  private_dns_zone_vnet_ids = [
    module.vnets["001"].virtual_network_id,
    module.vnets["002"].virtual_network_id,
  ]
}

module "private_endpoints" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  for_each = { for resource in local.resources : resource.name_suffix => resource }

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_cli        = module.region.location_cli
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix         = each.key
  private_dns_zone_id = module.private_dns_zone.private_dns_zone_id
  resource_id         = module.key_vaults[each.key].key_vault_id
  subnet_id           = module.subnets[each.key].subnet_id
}
