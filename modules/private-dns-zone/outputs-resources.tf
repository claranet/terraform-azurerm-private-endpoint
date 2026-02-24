output "id" {
  description = "Private DNS Zone ID."
  value       = azurerm_private_dns_zone.main.id
}

output "name" {
  description = "Private DNS Zone name."
  value       = azurerm_private_dns_zone.main.name
}

output "resource" {
  description = "Private DNS Zone resource object."
  value       = azurerm_private_dns_zone.main
}

output "resource_virtual_network_links" {
  description = "Private DNS Zone VNet link resource object."
  value       = azurerm_private_dns_zone_virtual_network_link.main
}

output "vnet_links_ids" {
  description = "VNet links IDs."
  value       = azurerm_private_dns_zone_virtual_network_link.main[*].id
}
