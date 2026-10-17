resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rules" {
  for_each         = var.firewall_rules
  name             = coalesce(each.value.name, each.key)
  server_id        = azurerm_postgresql_flexible_server.server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
