## 7.0.3 (2024-08-30)

### Bug Fixes

* remove lookup to fix lint 5dabdcf

### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 128eb28
* **AZ-1391:** update semantic-release config [skip ci] a309412

### Miscellaneous Chores

* **deps:** add renovate.json 473dd19
* **deps:** enable automerge on renovate 5323c2b
* **deps:** update dependency opentofu to v1.7.0 0e8175a
* **deps:** update dependency opentofu to v1.7.1 92e9ce6
* **deps:** update dependency opentofu to v1.7.2 8329977
* **deps:** update dependency opentofu to v1.7.3 8b635e8
* **deps:** update dependency opentofu to v1.8.0 7795d6a
* **deps:** update dependency opentofu to v1.8.1 2ad62c0
* **deps:** update dependency pre-commit to v3.7.1 aec6bb5
* **deps:** update dependency pre-commit to v3.8.0 5503a1a
* **deps:** update dependency terraform-docs to v0.18.0 feac1f6
* **deps:** update dependency tflint to v0.51.0 d193620
* **deps:** update dependency tflint to v0.51.1 a10e2c1
* **deps:** update dependency tflint to v0.51.2 d3e6b5d
* **deps:** update dependency tflint to v0.52.0 a2ea36b
* **deps:** update dependency trivy to v0.50.2 42ea263
* **deps:** update dependency trivy to v0.50.4 7dc5dd0
* **deps:** update dependency trivy to v0.51.0 cd06f14
* **deps:** update dependency trivy to v0.51.1 aa91c6a
* **deps:** update dependency trivy to v0.51.2 df07cbb
* **deps:** update dependency trivy to v0.51.4 486d3a0
* **deps:** update dependency trivy to v0.52.0 e632cd0
* **deps:** update dependency trivy to v0.52.1 eff73e2
* **deps:** update dependency trivy to v0.52.2 09dda2b
* **deps:** update dependency trivy to v0.53.0 e8de77c
* **deps:** update dependency trivy to v0.54.1 5b94d49
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 24c79af
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 69c086a
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 87e41d1
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 10491c7
* **deps:** update renovate.json 8b70d6d
* **deps:** update tools 3e18410
* **pre-commit:** update commitlint hook 9b11081
* **release:** remove legacy `VERSION` file 3db1c8e

# v7.0.2 - 2023-09-29

Fixed
  * AZ-1191: Fix tags truncation in `private-dns-zone` submodule

# v7.0.1 - 2023-07-13

Fixed
  * AZ-1113: Update sub-modules READMEs (according to their example)

# v7.0.0 - 2023-06-09

Added
  * AZ-1090: Add the `custom_network_interface_name` parameter to be able to define the custom NIC name of the Private Endpoint
  * AZ-1090: Add the `ip_configuration` block to be able to define the private IP address (or addresses) of the Private Endpoint

Breaking
  * AZ-1090: The minimum version of Terraform is now `1.3` to support optional attributes with default values

Changed
  * AZ-1090: The minimum version of the AzureRM Provider is now `3.36` to support new parameters
  * AZ-1090: Update example with new parameters

Fixed
  * AZ-1096: Fix the regex that does not match FHIR IDs

# v6.3.1 - 2023-03-10

Fixed
  * AZ-1023: Fix ResourceGroup name validation

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
