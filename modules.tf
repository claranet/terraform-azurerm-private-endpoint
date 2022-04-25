module "private_dns_zone" {
  source = "./modules/private-dns-zone"

  for_each = var.create_private_dns_zone ? toset(["private_dns_zone"]) : []

  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  private_dns_zone_name     = coalesce(try(local.subresources_mapping[var.subresource_name], null), local.resource_types_mapping[local.resource_type].private_dns_zone)
  private_dns_zone_vnet_ids = var.private_dns_zone_vnet_ids

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(local.default_tags, var.extra_tags)
}
