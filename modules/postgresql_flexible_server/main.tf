resource "random_password" "admin_password" {
  count            = var.administrator_password == null && var.create_mode == "Default" ? 1 : 0
  length           = var.admin_password_length
  special          = true
  override_special = "!#%*+,-./:=?_~"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

locals {
  admin_password = var.administrator_password != null ? var.administrator_password : (length(random_password.admin_password) > 0 ? random_password.admin_password[0].result : null)
}

resource "azurerm_postgresql_flexible_server" "server" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.server_version
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  storage_tier        = var.storage_tier
  auto_grow_enabled   = var.auto_grow_enabled

  backup_retention_days             = var.backup_retention_days
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  create_mode                       = var.create_mode
  source_server_id                  = var.source_server_id
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc
  zone                              = var.zone

  administrator_login    = var.create_mode == "Default" ? var.administrator_login : null
  administrator_password = var.create_mode == "Default" ? local.admin_password : null

  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "high_availability" {
    for_each = var.high_availability != null ? [var.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = try(high_availability.value.standby_availability_zone, null)
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      day_of_week  = try(maintenance_window.value.day_of_week, 0)
      start_hour   = try(maintenance_window.value.start_hour, 0)
      start_minute = try(maintenance_window.value.start_minute, 0)
    }
  }

  dynamic "authentication" {
    for_each = var.authentication != null ? [var.authentication] : []
    content {
      active_directory_auth_enabled = try(authentication.value.active_directory_auth_enabled, false)
      password_auth_enabled         = try(authentication.value.password_auth_enabled, true)
      tenant_id                     = try(authentication.value.tenant_id, null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id                  = customer_managed_key.value.key_vault_key_id
      primary_user_assigned_identity_id = customer_managed_key.value.primary_user_assigned_identity_id
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}
