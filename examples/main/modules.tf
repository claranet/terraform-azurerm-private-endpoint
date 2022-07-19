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

module "vnet_01" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = "01"

  vnet_cidr = ["192.168.1.0/24"]
}

module "subnet_01" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix          = "01"
  virtual_network_name = module.vnet_01.virtual_network_name

  enforce_private_link = true
  subnet_cidr_list     = ["192.168.1.128/25"]
}

module "vnet_02" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = "02"

  vnet_cidr = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "subnet_02" {
  name                = "snet-${var.stack}-${var.client_name}-${module.region.location_short}-${var.environment}-02"
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.vnet_02.virtual_network_name

  enforce_private_link_service_network_policies = true
  address_prefixes                              = ["172.16.4.0/24"]
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

module "lb" {
  source  = "claranet/lb/azurerm"
  version = "6.0.1"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  allocate_public_ip = true
}

resource "azurerm_private_link_service" "example" {
  name                = "pls-${var.stack}-${var.client_name}-${module.region.location_short}-${var.environment}"
  location            = module.region.location
  resource_group_name = module.rg.resource_group_name

  load_balancer_frontend_ip_configuration_ids = [module.lb.frontend_ip_configuration[0].id]

  nat_ip_configuration {
    name      = "default"
    primary   = true
    subnet_id = azurerm_subnet.subnet_02.id
  }
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

  name_suffix = "kv"

  subnet_id        = module.subnet_01.subnet_id
  target_resource  = module.key_vault.key_vault_id
  subresource_name = "vault"

  private_dns_zone_names    = ["privatelink.vaultcore.azure.net"]
  private_dns_zone_vnet_ids = [module.vnet_01.virtual_network_id, module.vnet_02.virtual_network_id]
}

module "example_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = "example"

  subnet_id       = azurerm_subnet.subnet_02.id
  target_resource = azurerm_private_link_service.example.id
}

module "example_alias_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.region.location
  location_short      = module.region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  name_suffix = "examplealias"

  subnet_id            = azurerm_subnet.subnet_02.id
  target_resource      = azurerm_private_link_service.example.alias
  is_manual_connection = true
}
