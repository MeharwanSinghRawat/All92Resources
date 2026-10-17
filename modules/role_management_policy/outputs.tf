output "id" {
  description = "The ID of the Role Management Policy."
  value       = azurerm_role_management_policy.policy.id
}

output "name" {
  description = "The Name of the Role Management Policy."
  value       = azurerm_role_management_policy.policy.name
}

output "description" {
  description = "The Description of the Role Management Policy."
  value       = azurerm_role_management_policy.policy.description
}

output "scope" {
  description = "The Scope of the Role Management Policy."
  value       = azurerm_role_management_policy.policy.scope
}

output "role_definition_id" {
  description = "The Role Definition ID associated with the policy."
  value       = azurerm_role_management_policy.policy.role_definition_id
}
