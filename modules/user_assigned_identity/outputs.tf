output "id" {
  description = "The ID of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.identity.id
}

output "principal_id" {
  description = "The Principal (Object) ID of the User Assigned Identity. Used for RBAC Role Assignments."
  value       = azurerm_user_assigned_identity.identity.principal_id
}

output "client_id" {
  description = "The Client (Application) ID of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.identity.client_id
}

output "tenant_id" {
  description = "The Tenant ID of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.identity.tenant_id
}

output "name" {
  description = "The Name of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.identity.name
}
