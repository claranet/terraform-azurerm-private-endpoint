module "private_dns_zones" {
  source = "./modules/private-dns-zone"

  for_each = toset(var.use_existing_private_dns_zones ? [] : var.private_dns_zones_names)

  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  name                = each.key
  virtual_network_ids = var.private_dns_zones_vnets_ids

  is_not_private_link_service = local.is_not_private_link_service

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(local.default_tags, var.extra_tags)
}
