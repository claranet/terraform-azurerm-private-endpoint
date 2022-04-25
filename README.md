# Azure Private Endpoint

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/private-endpoint/azurerm/)

This Terraform module creates an [Azure Private Endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) with the correct [Azure Private DNS Zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) as an option.

You can create a private DNS zone without creating a private endpoint by using the submodule `modules/private-dns-zone`.

<!-- BEGIN_TF_DOCS -->
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

```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | >= 2.15 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| private\_dns\_zone | ./modules/private-dns-zone | n/a |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.private_dns_zone_group](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.private_endpoint](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.private_service_connection](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| create\_private\_dns\_zone | Boolean to create the private DNS zone corresponding to the private endpoint. If you wish to centralize the DNS zone in another RG that could belong to another subscription, leave this option at `false` and use the 'private-dns-zone' submodule directly. | `bool` | `false` | no |
| custom\_private\_dns\_zone\_group\_name | Custom private DNS zone group name, generated if not set | `string` | `""` | no |
| custom\_private\_endpoint\_name | Custom private endpoint name, generated if not set | `string` | `""` | no |
| custom\_private\_service\_connection\_name | Custom private service connection name, generated if not set | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| location | Azure location | `string` | n/a | yes |
| location\_cli | CLI format for Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| private\_dns\_zone\_id | ID of the private DNS zone in which a new record will be created for the private endpoint, no private DNS zone group will be created if not set and `create_private_dns_zone = false`. When `private_dns_zone_id` is set and `create_private_dns_zone = true`, the ID of the private DNS zone created as part of the module overrides `private_dns_zone_id`. | `string` | `""` | no |
| private\_dns\_zone\_vnet\_ids | IDs of the VNets to link to the private DNS zone | `list(string)` | `[]` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| resource\_id | ID of the target resource | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_id | ID of the subnet in which the private endpoint will be created | `string` | n/a | yes |
| subresource\_name | Name of the subresource corresponding to the target Azure resource, useful when the subresource cannot be determined automatically, e.g. for Azure services such as Azure Storage, Azure Cosmos DB, etc. | `string` | `""` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. Custom names override this if set. Legacy default names is used if this is set to `false`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_dns\_zone\_id | ID of the private DNS zone |
| private\_dns\_zone\_name | Name of the private DNS zone |
| private\_dns\_zone\_vnet\_links\_ids | Map of VNets links IDs |
| private\_endpoint\_fqdn | The fully qualified domain name of the private endpoint |
| private\_endpoint\_id | ID of the private endpoint |
| private\_endpoint\_ip\_address | The private IP address associated with the private endpoint |
<!-- END_TF_DOCS -->