output "id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.asp.id
}

output "name" {
  description = "The Name of the App Service Plan."
  value       = azurerm_service_plan.asp.name
}

output "os_type" {
  description = "The Operating System type of the App Service Plan."
  value       = azurerm_service_plan.asp.os_type
}

output "sku_name" {
  description = "The SKU Name of the App Service Plan."
  value       = azurerm_service_plan.asp.sku_name
}

output "location" {
  description = "The Azure region where the App Service Plan is deployed."
  value       = azurerm_service_plan.asp.location
}

output "resource_group_name" {
  description = "The Resource Group name of the App Service Plan."
  value       = azurerm_service_plan.asp.resource_group_name
}
