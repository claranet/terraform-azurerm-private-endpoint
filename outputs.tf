#
# Private endpoint
#

output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = azurerm_private_endpoint.private_endpoint.id
}

output "private_endpoint_ip_address" {
  description = "The private IP address associated with the private endpoint"
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address
}

output "private_endpoint_fqdn" {
  description = "The fully qualified domain name of the private endpoint"
  value       = try(azurerm_private_endpoint.private_endpoint.private_dns_zone_configs[0].record_sets[0].fqdn, null)
}

#
# Private DNS zone
#

output "private_dns_zone_id" {
  description = "ID of the private DNS zone"
  value       = try(module.private_dns_zone["private_dns_zone"].private_dns_zone_id, null)
}

output "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  value       = try(module.private_dns_zone["private_dns_zone"].private_dns_zone_name, null)
}

output "private_dns_zone_vnet_links_ids" {
  description = "Map of VNets links IDs"
  value       = try(module.private_dns_zone["private_dns_zone"].private_dns_zone_vnet_links_ids, null)
}
