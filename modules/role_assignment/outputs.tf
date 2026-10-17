output "id" {
  description = "The ID of the Role Assignment."
  value       = azurerm_role_assignment.assignment.id
}

output "name" {
  description = "The Name (UUID) of the Role Assignment."
  value       = azurerm_role_assignment.assignment.name
}

output "scope" {
  description = "The Scope at which the Role Assignment was created."
  value       = azurerm_role_assignment.assignment.scope
}

output "principal_id" {
  description = "The Principal ID to which the role was assigned."
  value       = azurerm_role_assignment.assignment.principal_id
}

output "role_definition_id" {
  description = "The Role Definition ID that was assigned."
  value       = azurerm_role_assignment.assignment.role_definition_id
}
