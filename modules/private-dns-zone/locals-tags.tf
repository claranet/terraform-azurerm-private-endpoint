locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  combined_tags = merge(local.default_tags, var.extra_tags)

  fifteen_tags = {
    for key in slice(keys(local.combined_tags), 0, length(local.combined_tags) >= 15 ? 15 : length(local.combined_tags)) : key => lookup(local.combined_tags, key)
  }
}
