output "id" {
  description = "The ID of the Monitor Action Group."
  value       = azurerm_monitor_action_group.action_group.id
}

output "name" {
  description = "The name of the Monitor Action Group."
  value       = azurerm_monitor_action_group.action_group.name
}

output "short_name" {
  description = "The short name of the Monitor Action Group."
  value       = azurerm_monitor_action_group.action_group.short_name
}
