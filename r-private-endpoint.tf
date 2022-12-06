resource "azurerm_private_endpoint" "private_endpoint" {
  name     = local.private_endpoint_name
  location = var.location

  resource_group_name = var.resource_group_name

  subnet_id = var.subnet_id

  dynamic "private_dns_zone_group" {
    for_each = local.is_not_private_link_service ? ["private_dns_zone_group"] : []

    content {
      name                 = local.private_dns_zone_group_name
      private_dns_zone_ids = var.use_existing_private_dns_zones ? var.private_dns_zones_ids : [for zone in module.private_dns_zones : zone.private_dns_zone_id]
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
