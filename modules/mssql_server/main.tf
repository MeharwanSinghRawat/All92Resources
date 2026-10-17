resource "random_password" "password" {
  count            = var.administrator_login_password == null ? 1 : 0
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  admin_password = coalesce(var.administrator_login_password, try(random_password.password[0].result, null))
}

resource "azurerm_mssql_server" "server" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = local.admin_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? [var.azuread_administrator] : []
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }
}

resource "azurerm_mssql_database" "db" {
  for_each = var.databases

  name               = coalesce(each.value.name, each.key)
  server_id          = azurerm_mssql_server.server.id
  sku_name           = each.value.sku_name
  max_size_gb        = each.value.max_size_gb
  geo_backup_enabled = each.value.geo_backup_enabled
  collation          = each.value.collation
  tags               = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_mssql_firewall_rule" "rule" {
  for_each = var.firewall_rules

  name             = coalesce(each.value.name, each.key)
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
