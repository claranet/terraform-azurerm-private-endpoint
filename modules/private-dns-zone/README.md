# Azure Private DNS Zone

This terraform creates an [Azure Private DNS Zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) to be associated with an [Azure Private Endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint).

## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
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

  enforce_private_link = true
  subnet_cidr_list     = ["192.168.1.128/25"]
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
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |

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
| is\_not\_private\_link\_service | Boolean to determine if this module is used for Private Link Service or not | `bool` | `true` | no |
| private\_dns\_zone\_name | Private DNS Zone name | `string` | n/a | yes |
| private\_dns\_zone\_vnet\_ids | IDs of the VNets to link to the Private DNS Zone | `list(string)` | n/a | yes |
| registration\_enabled | Is auto-registration of VM records in the VNet in the Private DNS zone enabled? Defaults to `false`. | `bool` | `false` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_dns\_zone\_id | Private DNS Zone ID |
| private\_dns\_zone\_name | Private DNS Zone name |
| private\_dns\_zone\_vnet\_links\_ids | VNet links IDs |
<!-- END_TF_DOCS -->