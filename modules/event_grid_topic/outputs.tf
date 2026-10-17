output "id" {
  description = "The ID of the EventGrid Topic."
  value       = azurerm_eventgrid_topic.topic.id
}

output "name" {
  description = "The name of the EventGrid Topic."
  value       = azurerm_eventgrid_topic.topic.name
}

output "endpoint" {
  description = "The Endpoint associated with the EventGrid Topic."
  value       = azurerm_eventgrid_topic.topic.endpoint
}

output "primary_access_key" {
  description = "The Primary Shared Access Key associated with the EventGrid Topic."
  value       = azurerm_eventgrid_topic.topic.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The Secondary Shared Access Key associated with the EventGrid Topic."
  value       = azurerm_eventgrid_topic.topic.secondary_access_key
  sensitive   = true
}

output "subscriptions" {
  description = "Map of created Event Grid Subscription IDs."
  value = {
    for k, v in azurerm_eventgrid_event_subscription.subscriptions : k => v.id
  }
}
