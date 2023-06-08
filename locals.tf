locals {
  resource_alias = length(regexall("^([a-z0-9\\-]+)\\.([a-z0-9\\-]+)\\.([a-z]+)\\.(azure)\\.(privatelinkservice)$", var.target_resource)) == 1 ? var.target_resource : null
  resource_id    = length(regexall("^\\/(subscriptions)\\/([a-z0-9\\-]+)\\/(resourceGroups)\\/([A-Za-z0-9\\-_]+)\\/(providers)\\/([A-Za-z\\.]+)\\/([A-Za-z]+)\\/([A-Za-z0-9\\-]+)", var.target_resource)) == 1 ? var.target_resource : null

  is_not_private_link_service = local.resource_alias == null && !contains(try(split("/", local.resource_id), []), "privateLinkServices")
}
