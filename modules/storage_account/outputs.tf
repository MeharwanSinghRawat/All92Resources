output "id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.storage.id
}

output "name" {
  description = "The Name of the Storage Account."
  value       = azurerm_storage_account.storage.name
}

output "resource_group_name" {
  description = "The Resource Group where the Storage Account is created."
  value       = azurerm_storage_account.storage.resource_group_name
}

output "location" {
  description = "The Location of the Storage Account."
  value       = azurerm_storage_account.storage.location
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Storage Account."
  value       = azurerm_storage_account.storage.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the Storage Account."
  value       = azurerm_storage_account.storage.primary_blob_connection_string
  sensitive   = true
}

output "container_ids" {
  description = "Map of container keys to their resource IDs."
  value       = { for k, v in azurerm_storage_container.containers : k => v.id }
}

output "file_share_ids" {
  description = "Map of file share keys to their resource IDs."
  value       = { for k, v in azurerm_storage_share.file_shares : k => v.id }
}
