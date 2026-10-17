output "id" {
  description = "The ID of the PIM Active Role Assignment."
  value       = azurerm_pim_active_role_assignment.assignment.id
}

output "scope" {
  description = "The Scope at which the PIM Active Role Assignment was created."
  value       = azurerm_pim_active_role_assignment.assignment.scope
}

output "principal_id" {
  description = "The Principal ID to which the active role was assigned."
  value       = azurerm_pim_active_role_assignment.assignment.principal_id
}

output "principal_type" {
  description = "The type of the Principal assigned."
  value       = azurerm_pim_active_role_assignment.assignment.principal_type
}

output "role_definition_id" {
  description = "The Role Definition ID assigned."
  value       = azurerm_pim_active_role_assignment.assignment.role_definition_id
}
