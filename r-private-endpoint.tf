resource "azurerm_private_endpoint" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  custom_network_interface_name = var.nic_custom_name

  subnet_id = var.subnet_id

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name               = ip_configuration.value.name
      member_name        = local.is_not_private_link_service ? ip_configuration.value.member_name : null
      subresource_name   = local.is_not_private_link_service ? coalesce(ip_configuration.value.subresource_name, var.subresource_name) : null
      private_ip_address = ip_configuration.value.private_ip_address
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = local.is_not_private_link_service ? ["enabled"] : []
    content {
      name = local.private_dns_zone_group_name
      private_dns_zone_ids = var.use_existing_private_dns_zones ? var.private_dns_zones_ids : [
        for zone in module.private_dns_zones : zone.private_dns_zone_id
      ]
    }
  }

  private_service_connection {
    name                              = local.private_service_connection_name
    is_manual_connection              = var.is_manual_connection
    request_message                   = var.is_manual_connection ? var.request_message : null
    private_connection_resource_id    = local.resource_id
    private_connection_resource_alias = local.resource_alias
    subresource_names                 = local.is_not_private_link_service ? [var.subresource_name] : null
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_private_endpoint.private_endpoint
  to   = azurerm_private_endpoint.main
}
