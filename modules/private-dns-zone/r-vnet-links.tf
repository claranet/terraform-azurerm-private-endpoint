resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count = length(var.virtual_network_ids)

  name = format("%s-link", reverse(split("/", var.virtual_network_ids[count.index]))[0])

  # AzureRM 5.0 replaced `private_dns_zone_name` + `resource_group_name` with `private_dns_zone_id`.
  private_dns_zone_id = azurerm_private_dns_zone.main.id
  virtual_network_id  = var.virtual_network_ids[count.index]

  registration_enabled = var.vm_autoregistration_enabled

  # NxDomainRedirect enables internet fallback for the Private DNS Zone
  resolution_policy = length(regexall("(.*\\.)?(privatelink)\\.*", azurerm_private_dns_zone.main.name)) > 0 ? (var.internet_fallback_enabled ? "NxDomainRedirect" : "Default") : null

  tags = local.curtailed_tags

  lifecycle {
    precondition {
      condition     = var.is_not_private_link_service
      error_message = "Private Link Service does not require the deployment of Private DNS Zone VNet Links."
    }
  }
}

moved {
  from = azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links
  to   = azurerm_private_dns_zone_virtual_network_link.main
}
