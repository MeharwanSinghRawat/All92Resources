resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each  = var.databases
  name      = coalesce(each.value.name, each.key)
  server_id = azurerm_postgresql_flexible_server.server.id
  charset   = try(each.value.charset, "UTF8")
  collation = try(each.value.collation, "en_US.utf8")
}
