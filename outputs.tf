output "private_endpoint_id" {
  description = "Private Endpoint ID."
  value       = azurerm_private_endpoint.private_endpoint.id
}

output "private_endpoint_ip_address" {
  description = "IP address associated with the Private Endpoint."
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address
}

output "private_dns_zones_ids" {
  description = "Maps of Private DNS Zones IDs created as part of this module. Only available if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service."
  value       = { for config in azurerm_private_endpoint.private_endpoint.private_dns_zone_configs : config.name => config.private_dns_zone_id }
}

output "private_dns_zones_record_sets" {
  description = "Maps of Private DNS Zones record sets created as part of this module. Only available if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service."
  value       = { for config in azurerm_private_endpoint.private_endpoint.private_dns_zone_configs : config.name => config.record_sets }
}
