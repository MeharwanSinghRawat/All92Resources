output "id" {
  description = "The ID of the Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "name" {
  description = "The Name of the Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The Azure Region where the Resource Group is located."
  value       = azurerm_resource_group.rg.location
}

output "tags" {
  description = "The tags assigned to the Resource Group."
  value       = azurerm_resource_group.rg.tags
}

output "lock_id" {
  description = "The ID of the Management Lock applied to the Resource Group, if enabled."
  value       = try(azurerm_management_lock.rg_lock["this"].id, null)
}
