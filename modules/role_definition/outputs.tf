output "id" {
  description = "The ID of the Custom Role Definition."
  value       = azurerm_role_definition.role.id
}

output "role_definition_id" {
  description = "The unique UUID of the Custom Role Definition."
  value       = azurerm_role_definition.role.role_definition_id
}

output "role_definition_resource_id" {
  description = "The Azure Resource Manager ID for the resource."
  value       = azurerm_role_definition.role.role_definition_resource_id
}

output "name" {
  description = "The Name of the Custom Role Definition."
  value       = azurerm_role_definition.role.name
}

output "scope" {
  description = "The primary scope of the Custom Role Definition."
  value       = azurerm_role_definition.role.scope
}
