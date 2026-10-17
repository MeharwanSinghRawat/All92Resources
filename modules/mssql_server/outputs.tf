output "id" {
  description = "The Microsoft SQL Server ID."
  value       = azurerm_mssql_server.server.id
}

output "name" {
  description = "The Microsoft SQL Server name."
  value       = azurerm_mssql_server.server.name
}

output "fully_qualified_domain_name" {
  description = "The fully qualified domain name of the Azure SQL Server (e.g. servername.database.windows.net)."
  value       = azurerm_mssql_server.server.fully_qualified_domain_name
}

output "administrator_login" {
  description = "The administrator login of the Azure SQL Server."
  value       = azurerm_mssql_server.server.administrator_login
}

output "administrator_password" {
  description = "The administrator password of the Azure SQL Server."
  value       = local.admin_password
  sensitive   = true
}

output "databases" {
  description = "Map of created SQL Databases with their IDs and names."
  value = {
    for k, v in azurerm_mssql_database.db : k => {
      id   = v.id
      name = v.name
    }
  }
}
