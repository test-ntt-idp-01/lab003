terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.71.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      #      version = "~> 2.15.0"
    }
  }
}
