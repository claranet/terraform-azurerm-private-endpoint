locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  private_endpoint_name           = coalesce(var.custom_private_endpoint_name, data.azurecaf_name.private_endpoint.result)
  private_dns_zone_group_name     = coalesce(var.custom_private_dns_zone_group_name, data.azurecaf_name.private_dns_zone_group.result)
  private_service_connection_name = coalesce(var.custom_private_service_connection_name, data.azurecaf_name.private_service_connection.result)
}
