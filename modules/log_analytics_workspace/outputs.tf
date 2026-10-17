output "id" {
  description = "The Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.workspace.id
}

output "name" {
  description = "The Log Analytics Workspace name."
  value       = azurerm_log_analytics_workspace.workspace.name
}

output "workspace_id" {
  description = "The Workspace (Customer) ID for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.workspace.workspace_id
}

output "primary_shared_key" {
  description = "The Primary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.workspace.primary_shared_key
  sensitive   = true
}

output "secondary_shared_key" {
  description = "The Secondary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.workspace.secondary_shared_key
  sensitive   = true
}
