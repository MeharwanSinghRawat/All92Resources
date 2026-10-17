output "id" {
  description = "The ServiceBus Namespace ID."
  value       = azurerm_servicebus_namespace.namespace.id
}

output "name" {
  description = "The ServiceBus Namespace name."
  value       = azurerm_servicebus_namespace.namespace.name
}

output "endpoint" {
  description = "The ServiceBus Namespace endpoint URL."
  value       = azurerm_servicebus_namespace.namespace.endpoint
}

output "default_primary_connection_string" {
  description = "The primary connection string for the RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.namespace.default_primary_connection_string
  sensitive   = true
}

output "default_primary_key" {
  description = "The primary access key for the RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.namespace.default_primary_key
  sensitive   = true
}

output "queues" {
  description = "Map of created queues with IDs."
  value = {
    for k, v in azurerm_servicebus_queue.queue : k => v.id
  }
}

output "topics" {
  description = "Map of created topics with IDs."
  value = {
    for k, v in azurerm_servicebus_topic.topic : k => v.id
  }
}
