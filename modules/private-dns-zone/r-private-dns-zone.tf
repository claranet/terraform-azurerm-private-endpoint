resource "azurerm_private_dns_zone" "main" {
  name = var.name

  resource_group_name = var.resource_group_name

  tags = local.curtailed_tags

  lifecycle {
    precondition {
      condition     = var.is_not_private_link_service
      error_message = "Private Link Service does not require the deployment of Private DNS Zones."
    }
  }
}

moved {
  from = azurerm_private_dns_zone.private_dns_zone
  to   = azurerm_private_dns_zone.main
}
