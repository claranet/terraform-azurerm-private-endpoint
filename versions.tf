terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.15"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.1"
    }
  }
}
