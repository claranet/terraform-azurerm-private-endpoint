resource "azurerm_private_endpoint" "private_endpoint" {
  name                = local.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id = var.subnet_id

  dynamic "private_dns_zone_group" {
    for_each = var.create_private_dns_zone || var.private_dns_zone_id != "" ? ["private_dns_zone_group"] : []

    content {
      name                 = local.private_dns_zone_group_name
      private_dns_zone_ids = [coalesce(try(module.private_dns_zone["private_dns_zone"].private_dns_zone_id, null), var.private_dns_zone_id)]
    }
  }

  private_service_connection {
    name                           = local.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = var.resource_id
    subresource_names              = [coalesce(var.subresource_name, local.resource_types_mapping[local.resource_type].subresource)]
  }

  tags = merge(local.default_tags, var.extra_tags)
}
