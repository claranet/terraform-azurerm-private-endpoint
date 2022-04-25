# Azure Private DNS Zone

This terraform creates a private DNS zone to be associated with a private endpoint.

## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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

```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| private\_dns\_zone\_name | Name of the private DNS zone name | `string` | n/a | yes |
| private\_dns\_zone\_vnet\_ids | IDs of the VNets to link to the private DNS zone | `list(string)` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_dns\_zone\_id | ID of the private DNS zone |
| private\_dns\_zone\_name | Name of the private DNS zone |
| private\_dns\_zone\_vnet\_links\_ids | Map of VNets links IDs |
<!-- END_TF_DOCS -->