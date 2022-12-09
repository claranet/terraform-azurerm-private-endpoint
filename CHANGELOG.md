# v6.3.0 - 2022-12-09

Changed
  * AZ-929: Change the `private_dns_zone_ids` variable to `private_dns_zones_ids`
  * AZ-929: Change the `private_dns_zone_names` variable to `private_dns_zones_names`
  * AZ-929: Change the `private_dns_zone_vnet_ids` variable to `private_dns_zones_vnets_ids`
  * AZ-929: Change the `private_dns_zone_vnet_ids` submodule variable to `private_dns_zone_vnets_ids`
  * AZ-929: Revamp some variables descriptions
  * AZ-929: Change the `private_dns_zone_ids` output to `private_dns_zones_ids`
  * AZ-929: Change the `private_dns_zone_record_sets` output to `private_dns_zones_record_sets`
  * AZ-929: Better handling of limited tags on Private DNS Zone and Private DNS Zone VNet Link resources
  * AZ-929: Improve code
  * AZ-929: Update README (with examples)

# v6.2.0 - 2022-11-24

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v6.1.1 - 2022-10-14

Changed
  * AZ-844: `enforce_private_link_endpoint_network_policies` will be removed in favour of the property `private_endpoint_network_policies_enabled` on subnet module (`v6.0+`)

# v6.1.0 - 2022-08-19

Added
  * AZ-827: Add `registration_enabled` parameter to Private DNS Zone submodule

# v6.0.0 - 2022-08-05

Added
  * AZ-598: Initialize Private Endpoint module
