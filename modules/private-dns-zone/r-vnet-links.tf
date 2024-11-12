resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count = length(var.virtual_network_ids)

  name = format("%s-link", reverse(split("/", var.virtual_network_ids[count.index]))[0])

  resource_group_name = var.resource_group_name

  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = var.virtual_network_ids[count.index]

  registration_enabled = var.vm_autoregistration_enabled

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
