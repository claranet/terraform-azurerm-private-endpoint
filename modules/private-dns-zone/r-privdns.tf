resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  # Only 15 tags are supported on this resource
  tags = { for key in slice(keys(local.combined_tags), 0, length(local.combined_tags) >= 15 ? 15 : length(local.combined_tags)) : key => lookup(local.combined_tags, key) }
}
