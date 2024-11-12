# Azure Private DNS Zone

This terraform creates an [Azure Private DNS Zone](https://learn.microsoft.com/en-us/azure/dns/private-dns-overview/) to be associated with an [Azure Private Endpoint](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview/).

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

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
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
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| is\_not\_private\_link\_service | Boolean to determine if this module is used for Private Link Service or not. | `bool` | `true` | no |
| name | Private DNS Zone name. | `string` | n/a | yes |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| virtual\_network\_ids | IDs of the Virtual Networks to link to the Private DNS Zone. | `list(string)` | n/a | yes |
| vm\_autoregistration\_enabled | Is auto-registration of VM records in the VNet in the Private DNS zone enabled? Defaults to `false`. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Private DNS Zone ID. |
| name | Private DNS Zone name. |
| resource | Private DNS Zone resource object. |
| resource\_virtual\_network\_links | Private DNS Zone VNet link resource object. |
| vnet\_links\_ids | VNet links IDs. |
<!-- END_TF_DOCS -->
