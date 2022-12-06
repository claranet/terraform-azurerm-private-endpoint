output "private_dns_zone_id" {
  description = "Private DNS Zone ID."
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "private_dns_zone_name" {
  description = "Private DNS Zone name."
  value       = azurerm_private_dns_zone.private_dns_zone.name
}

output "private_dns_zone_vnet_links_ids" {
  description = "VNet links IDs."
  value       = azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links[*].id
}
