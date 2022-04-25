output "private_dns_zone_id" {
  description = "ID of the private DNS zone"
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  value       = azurerm_private_dns_zone.private_dns_zone.name
}

output "private_dns_zone_vnet_links_ids" {
  description = "Map of VNets links IDs"
  value       = { for vnet_id in var.private_dns_zone_vnet_ids : split("/", vnet_id)[8] => azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links[element(split("/", vnet_id), 8)].id }
}
