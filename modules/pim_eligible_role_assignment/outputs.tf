output "id" {
  description = "The ID of the PIM Eligible Role Assignment."
  value       = azurerm_pim_eligible_role_assignment.assignment.id
}

output "scope" {
  description = "The Scope of the PIM Eligible Role Assignment."
  value       = azurerm_pim_eligible_role_assignment.assignment.scope
}

output "principal_id" {
  description = "The Principal ID made eligible for the role."
  value       = azurerm_pim_eligible_role_assignment.assignment.principal_id
}

output "principal_type" {
  description = "The type of Principal made eligible."
  value       = azurerm_pim_eligible_role_assignment.assignment.principal_type
}

output "role_definition_id" {
  description = "The Role Definition ID configured for eligibility."
  value       = azurerm_pim_eligible_role_assignment.assignment.role_definition_id
}
