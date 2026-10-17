output "id" {
  description = "The ID of the Metric Alert."
  value       = azurerm_monitor_metric_alert.alert.id
}

output "name" {
  description = "The name of the Metric Alert."
  value       = azurerm_monitor_metric_alert.alert.name
}
