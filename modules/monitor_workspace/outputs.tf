output "id" {
  description = "The ID of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.workspace.id
}

output "name" {
  description = "The Name of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.workspace.name
}

output "query_endpoint" {
  description = "The query endpoint URL for the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.workspace.query_endpoint
}

output "default_data_collection_endpoint_id" {
  description = "The ID of the managed default Data Collection Endpoint created with the workspace."
  value       = azurerm_monitor_workspace.workspace.default_data_collection_endpoint_id
}

output "default_data_collection_rule_id" {
  description = "The ID of the managed default Data Collection Rule created with the workspace."
  value       = azurerm_monitor_workspace.workspace.default_data_collection_rule_id
}

output "prometheus_rule_group_ids" {
  description = "Map of created Prometheus rule group names to their resource IDs."
  value       = { for k, v in azurerm_monitor_alert_prometheus_rule_group.rule_group : k => v.id }
}
