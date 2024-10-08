# Azure Private Endpoint

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/private-endpoint/azurerm/)

This Terraform module creates an [Azure Private Endpoint](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview/) with one or more [Azure Private DNS Zones](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview/) as an option.

You can create Private DNS Zones without creating a Private Endpoint by using the submodule `modules/private-dns-zone`.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "vnet_01" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "01"

  vnet_cidr = ["192.168.1.0/24"]
}

module "subnet_01" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
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

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "02"

  vnet_cidr = ["172.16.0.0/16"]
}

module "subnet_02" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "02"

  virtual_network_name = module.vnet_02.virtual_network_name

  private_link_endpoint_enabled = true
  private_link_service_enabled  = false

  subnet_cidr_list = ["172.16.4.0/24"]
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
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

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  allocate_public_ip = true
}

resource "azurerm_private_link_service" "example" {
  name     = format("pls-%s-%s-%s-%s", var.stack, var.client_name, module.azure_region.location_short, var.environment)
  location = module.azure_region.location

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

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "kv"

  custom_private_endpoint_nic_name = "foo"

  subnet_id = module.subnet_01.subnet_id
  ip_configurations = [{           # The number of IP configurations depends on the target resource
    member_name        = "default" # The `member_name` value depends on the target resource
    private_ip_address = cidrhost(module.subnet_01.subnet_cidr_list[0], 34)
  }]

  target_resource  = module.key_vault.key_vault_id
  subresource_name = "vault"

  private_dns_zones_names     = ["privatelink.vaultcore.azure.net"]
  private_dns_zones_vnets_ids = [module.vnet_01.virtual_network_id, module.vnet_02.virtual_network_id]
}

module "example_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "example"

  custom_private_endpoint_nic_name = "bar"

  subnet_id = module.subnet_02.subnet_id

  target_resource = azurerm_private_link_service.example.id
}

module "example_alias_private_endpoint" {
  source  = "claranet/private-endpoint/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  name_suffix = "examplealias"

  is_manual_connection = true

  subnet_id = module.subnet_02.subnet_id
  ip_configurations = [{
    private_ip_address = cidrhost(module.subnet_02.subnet_cidr_list[0], 34)
  }]

  target_resource = azurerm_private_link_service.example.alias
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| private\_dns\_zones | ./modules/private-dns-zone | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurecaf_name.private_dns_zone_group](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.private_endpoint](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.private_service_connection](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_private\_dns\_zone\_group\_name | Custom Private DNS Zone Group name, generated if not set. | `string` | `""` | no |
| custom\_private\_endpoint\_name | Custom Private Endpoint name, generated if not set. | `string` | `""` | no |
| custom\_private\_endpoint\_nic\_name | Custom network interface name of the Private endpoint, generated by Azure if not set. | `string` | `null` | no |
| custom\_private\_service\_connection\_name | Custom Private Service Connection name, generated if not set. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| ip\_configurations | List of IP Configuration object. Any modification to the parameters of the IP Configuration object forces a new resource to be created.<pre>name               = Name of the IP Configuration.<br/>member_name        = Member name of the IP Configuration. If it is not specified, it will use the value of `subresource_name`. Only valid if `target_resource` is not a Private Link Service.<br/>subresource_name   = Subresource name of the IP Configuration. Only valid if `target_resource` is not a Private Link Service.<br/>private_ip_address = Private IP address within the Subnet of the Private Endpoint.</pre> | <pre>list(object({<br/>    name               = optional(string, "default")<br/>    member_name        = optional(string)<br/>    subresource_name   = optional(string)<br/>    private_ip_address = string<br/>  }))</pre> | `[]` | no |
| is\_manual\_connection | Does the Private Endpoint require manual approval from the remote resource owner? Default to `false`. | `bool` | `false` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| private\_dns\_zones\_ids | IDs of the Private DNS Zones in which a new record will be created for the Private Endpoint. Only valid if `use_existing_private_dns_zones` is set to `true` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified. | `list(string)` | `[]` | no |
| private\_dns\_zones\_names | Names of the Private DNS Zones to create. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified. | `list(string)` | `[]` | no |
| private\_dns\_zones\_vnets\_ids | IDs of the VNets to link to the Private DNS Zones. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. | `list(string)` | `[]` | no |
| request\_message | A message passed to the owner of the remote resource when the Private Endpoint attempts to establish the connection to the remote resource. Only valid if `is_manual_connection` is set to `true`. | `string` | `"Private Endpoint Deployment"` | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| subnet\_id | ID of the subnet in which the Private Endpoint will be created. | `string` | n/a | yes |
| subresource\_name | Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service. | `string` | `""` | no |
| target\_resource | Private Link Service Alias or ID of the target resource. | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. Custom names override this if set. Legacy default names is used if this is set to `false`. | `bool` | `true` | no |
| use\_existing\_private\_dns\_zones | Boolean to create the Private DNS Zones corresponding to the Private Endpoint. If you wish to centralize the Private DNS Zones in another Resource Group that could belong to another subscription, set this option to `true` and use the `private-dns-zone` submodule directly. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_dns\_zones\_ids | Maps of Private DNS Zones IDs created as part of this module. Only available if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. |
| private\_dns\_zones\_record\_sets | Maps of Private DNS Zones record sets created as part of this module. Only available if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. |
| private\_endpoint\_id | Private Endpoint ID. |
| private\_endpoint\_ip\_address | IP address associated with the Private Endpoint. |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/private-link/](https://docs.microsoft.com/en-us/azure/private-link/)
