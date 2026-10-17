output "id" {
  description = "The ID of the Marketplace Role Assignment."
  value       = azurerm_marketplace_role_assignment.assignment.id
}

output "name" {
  description = "The Name (UUID) of the Marketplace Role Assignment."
  value       = azurerm_marketplace_role_assignment.assignment.name
}

output "principal_type" {
  description = "The type of the Principal to which the role was assigned."
  value       = azurerm_marketplace_role_assignment.assignment.principal_type
}
