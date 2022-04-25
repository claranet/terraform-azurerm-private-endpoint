locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  combined_tags = merge(local.default_tags, var.extra_tags)
}
