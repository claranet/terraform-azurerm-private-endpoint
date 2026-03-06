output "id" {
  description = "Private Endpoint ID."
  value       = azurerm_private_endpoint.main.id
}

output "name" {
  description = "Private Endpoint name."
  value       = azurerm_private_endpoint.main.name
}

output "resource" {
  description = "Azure Private Endpoint resource object."
  value       = azurerm_private_endpoint.main
}

output "ip_address" {
  description = "IP address associated with the Private Endpoint."
  value       = azurerm_private_endpoint.main.private_service_connection[0].private_ip_address
}

output "module_private_dns_zone" {
  description = "Azure Private DNS Zone module outputs."
  value       = module.private_dns_zones
}
