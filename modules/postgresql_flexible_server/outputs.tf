output "id" {
  description = "The ID of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.server.id
}

output "name" {
  description = "The Name of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.server.name
}

output "fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.server.fqdn
}

output "administrator_login" {
  description = "The Administrator login for the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.server.administrator_login
}

output "administrator_password" {
  description = "The password associated with the administrator_login for the PostgreSQL Flexible Server."
  value       = local.admin_password
  sensitive   = true
}

output "public_network_access_enabled" {
  description = "Whether public network access is enabled on the server."
  value       = azurerm_postgresql_flexible_server.server.public_network_access_enabled
}

output "database_ids" {
  description = "A map of created database names to their resource IDs."
  value       = { for k, v in azurerm_postgresql_flexible_server_database.databases : k => v.id }
}

output "firewall_rule_ids" {
  description = "A map of created firewall rule names to their resource IDs."
  value       = { for k, v in azurerm_postgresql_flexible_server_firewall_rule.firewall_rules : k => v.id }
}
