resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_links" {
  for_each = { for vnet_id in var.private_dns_zone_vnet_ids : split("/", vnet_id)[8] => vnet_id }

  name                  = "${each.key}-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = each.value

  # Only 15 tags are supported on this resource
  tags = { for key in slice(keys(local.combined_tags), 0, length(local.combined_tags) >= 15 ? 15 : length(local.combined_tags)) : key => lookup(local.combined_tags, key) }
}
