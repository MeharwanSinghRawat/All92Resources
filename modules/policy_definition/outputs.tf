output "id" {
  description = "The ID of the Policy Definition."
  value       = azurerm_policy_definition.policy.id
}

output "name" {
  description = "The Name of the Policy Definition."
  value       = azurerm_policy_definition.policy.name
}

output "role_definition_ids" {
  description = "The Role Definition IDs associated with the policy (if any)."
  value       = azurerm_policy_definition.policy.role_definition_ids
}
