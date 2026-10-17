resource "azurerm_postgresql_flexible_server_configuration" "configurations" {
  for_each  = var.server_configurations
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.server.id
  value     = each.value
}
