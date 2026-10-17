terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }

  # Remote backend for production-grade state storage in Azure Storage Account
  backend "azurerm" {
    resource_group_name  = "rg-enterprise-dev-mgmt-eastus2"
    storage_account_name = "stoneaimtfstatedev"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
