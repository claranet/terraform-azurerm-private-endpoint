## 8.0.2 (2025-10-01)

### Code Refactoring

* **deps:** 🔗 update claranet/azurecaf to ~> 1.3.0 🔧 e253c88

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review 540b939
* 🗑️ remove old commitlint configuration files 31646d9
* **deps:** 🔗 bump AzureRM provider version to v4.31+ 8ab4311
* **deps:** update dependency opentofu to v1.10.0 b6d5139
* **deps:** update dependency opentofu to v1.10.1 f184e8c
* **deps:** update dependency opentofu to v1.10.3 8105ccb
* **deps:** update dependency opentofu to v1.10.6 310af1c
* **deps:** update dependency opentofu to v1.9.1 f552f50
* **deps:** update dependency terraform-docs to v0.20.0 5f7eef8
* **deps:** update dependency tflint to v0.58.0 37bee94
* **deps:** update dependency tflint to v0.58.1 9061673
* **deps:** update dependency tflint to v0.59.1 673d5df
* **deps:** update dependency trivy to v0.61.1 6722d15
* **deps:** update dependency trivy to v0.63.0 cb23d46
* **deps:** update dependency trivy to v0.66.0 1a27389
* **deps:** update dependency trivy to v0.67.0 f14ac04
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v6 7995924
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 52b7461
* **deps:** update tools 61bb9dd
* **deps:** update tools d365f7d
* **deps:** update tools e670c49
* **deps:** update tools 814147e

## 8.0.1 (2025-04-01)

### Bug Fixes

* use the right `id` output from local private DNS zone submodule 6fd9a71

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.8 131ff28
* **deps:** update dependency opentofu to v1.9.0 7de2217
* **deps:** update dependency pre-commit to v4.1.0 b9090d9
* **deps:** update dependency pre-commit to v4.2.0 29bc2bb
* **deps:** update dependency tflint to v0.55.0 49c1a4c
* **deps:** update dependency trivy to v0.58.1 6ee6b78
* **deps:** update dependency trivy to v0.58.2 8761b16
* **deps:** update dependency trivy to v0.59.1 9e13369
* **deps:** update dependency trivy to v0.60.0 29b4fe2
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 9c15d23
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 26faae1
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 01a12c9
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 7015d0d
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 b71a872
* **deps:** update tools 4eaabab
* **deps:** update tools 506e373
* **deps:** update tools ebb6eba
* update Github templates 82847b8
* update tflint config for v0.55.0 8b9d229

## 8.0.0 (2024-11-26)

### ⚠ BREAKING CHANGES

* **AZ-1088:** module v8 structure and updates

### Features

* **AZ-1088:** module v8 structure and updates 02892bf

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.4 3732066
* **deps:** update dependency opentofu to v1.8.6 0876028
* **deps:** update dependency pre-commit to v4.0.1 246e53a
* **deps:** update dependency tflint to v0.54.0 fcc6836
* **deps:** update dependency trivy to v0.56.2 1b87f9d
* **deps:** update dependency trivy to v0.57.1 80c86e9
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 c7f99e2
* **deps:** update tools ec4937c
* update examples structure 7230c75

## 7.1.1 (2024-10-08)

### Documentation

* update submodule READMEs with latest template 5ba7326

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.3 2ac5d87
* **deps:** update dependency pre-commit to v4 51f3631
* **deps:** update dependency trivy to v0.56.0 085e5b2
* **deps:** update dependency trivy to v0.56.1 fe292a4
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 265b113
* prepare for new examples structure afd1a57

## 7.1.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 4a86c0e

### Documentation

* update README badge to use OpenTofu registry 7bb01aa
* update README with `terraform-docs` v0.19.0 f3dc4d8

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.2 43fc259
* **deps:** update dependency terraform-docs to v0.19.0 8124543
* **deps:** update dependency trivy to v0.55.0 112f62b
* **deps:** update dependency trivy to v0.55.1 afbaf63
* **deps:** update dependency trivy to v0.55.2 4a53610
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 998f2de
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 4094a27
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 8877abe
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 4d1a8d1
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 45e9938
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 33c729c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 458e110

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
