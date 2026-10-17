output "id" {
  description = "The ID of the EventHub Namespace."
  value       = azurerm_eventhub_namespace.namespace.id
}

output "name" {
  description = "The name of the EventHub Namespace."
  value       = azurerm_eventhub_namespace.namespace.name
}

output "default_primary_connection_string" {
  description = "The primary connection string for the specified EventHub Namespace authorization rule."
  value       = azurerm_eventhub_namespace.namespace.default_primary_connection_string
  sensitive   = true
}

output "default_primary_key" {
  description = "The primary access key for the authorization rule RootManageSharedAccessKey."
  value       = azurerm_eventhub_namespace.namespace.default_primary_key
  sensitive   = true
}

output "eventhubs" {
  description = "Map of created Event Hub IDs."
  value = {
    for k, v in azurerm_eventhub.hubs : k => v.id
  }
}
