output "id" {
  description = "The ID of the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.id
}

output "name" {
  description = "The name of the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.name
}

output "endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = azurerm_cosmosdb_account.account.endpoint
}

output "read_endpoints" {
  description = "A list of read endpoints available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.account.read_endpoints
}

output "write_endpoints" {
  description = "A list of write endpoints available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.account.write_endpoints
}

output "primary_key" {
  description = "The Primary key for the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.primary_key
  sensitive   = true
}

output "secondary_key" {
  description = "The Secondary key for the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.secondary_key
  sensitive   = true
}

output "primary_readonly_key" {
  description = "The Primary read-only key for the CosmosDB Account."
  value       = azurerm_cosmosdb_account.account.primary_readonly_key
  sensitive   = true
}

output "sql_databases" {
  description = "Map of created SQL database IDs."
  value = {
    for k, v in azurerm_cosmosdb_sql_database.databases : k => v.id
  }
}

output "sql_containers" {
  description = "Map of created SQL container IDs."
  value = {
    for k, v in azurerm_cosmosdb_sql_container.containers : k => v.id
  }
}
