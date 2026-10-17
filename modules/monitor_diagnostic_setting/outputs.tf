output "id" {
  description = "The ID of the Diagnostic Setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.id
}

output "name" {
  description = "The name of the Diagnostic Setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.name
}

output "target_resource_id" {
  description = "The ID of the Target Resource."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.target_resource_id
}

output "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID used as a destination."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.log_analytics_workspace_id
}

output "storage_account_id" {
  description = "The Storage Account ID used as a destination."
  value       = azurerm_monitor_diagnostic_setting.diagnostic_setting.storage_account_id
}
