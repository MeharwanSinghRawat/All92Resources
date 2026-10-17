resource "azurerm_postgresql_flexible_server_active_directory_administrator" "ad_admin" {
  count               = var.ad_admin != null ? 1 : 0
  server_name         = azurerm_postgresql_flexible_server.server.name
  resource_group_name = var.resource_group_name
  tenant_id           = var.ad_admin.tenant_id
  object_id           = var.ad_admin.object_id
  principal_name      = var.ad_admin.principal_name
  principal_type      = var.ad_admin.principal_type
}
