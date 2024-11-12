module "vnet_01" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "01"

  cidrs = ["192.168.1.0/24"]
}

module "subnet_01" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "01"

  virtual_network_name = module.vnet_01.name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = true

  cidrs = ["192.168.1.128/25"]
}

module "vnet_02" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "02"

  cidrs = ["172.16.0.0/16"]
}

module "subnet_02" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "02"

  virtual_network_name = module.vnet_02.name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = false

  cidrs = ["172.16.4.0/24"]
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

module "lb" {
  source  = "claranet/lb/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  public_ip_allocated = true
}

resource "azurerm_private_link_service" "example" {
  name                = format("pls-%s-%s-%s-%s", var.stack, var.client_name, module.azure_region.location_short, var.environment)
  location            = module.azure_region.location
  resource_group_name = module.rg.name

  load_balancer_frontend_ip_configuration_ids = [module.lb.frontend_ip_configuration[0].id]

  nat_ip_configuration {
    name      = "default"
    primary   = true
    subnet_id = module.subnet_02.id
  }
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

  name_suffix = "kv"

  nic_custom_name = "foo"

  subnet_id = module.subnet_01.id
  ip_configurations = [{           # The number of IP configurations depends on the target resource
    member_name        = "default" # The `member_name` value depends on the target resource
    private_ip_address = cidrhost(module.subnet_01.cidrs[0], 34)
  }]

  target_resource  = module.key_vault.id
  subresource_name = "vault"

  private_dns_zones_names     = ["privatelink.vaultcore.azure.net"]
  private_dns_zones_vnets_ids = [module.vnet_01.id, module.vnet_02.id]
}

module "example_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "example"

  nic_custom_name = "bar"

  subnet_id = module.subnet_02.id

  target_resource = azurerm_private_link_service.example.id
}

module "example_alias_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  name_suffix = "examplealias"

  is_manual_connection = true

  subnet_id = module.subnet_02.id
  ip_configurations = [{
    private_ip_address = cidrhost(module.subnet_02.cidrs[0], 34)
  }]

  target_resource = azurerm_private_link_service.example.alias
}
