resource "azurerm_redis_cache" "redis" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  non_ssl_port_enabled          = var.non_ssl_port_enabled
  minimum_tls_version           = var.minimum_tls_version
  private_static_ip_address     = var.private_static_ip_address
  subnet_id                     = var.subnet_id
  public_network_access_enabled = var.public_network_access_enabled
  redis_version                 = var.redis_version
  zones                         = length(var.zones) > 0 ? var.zones : null
  tags                          = var.tags

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  redis_configuration {
    authentication_enabled          = try(var.redis_configuration.authentication_enabled, true)
    maxmemory_reserved              = try(var.redis_configuration.maxmemory_reserved, null)
    maxmemory_delta                 = try(var.redis_configuration.maxmemory_delta, null)
    maxmemory_policy                = try(var.redis_configuration.maxmemory_policy, "volatile-lru")
    maxfragmentationmemory_reserved = try(var.redis_configuration.maxfragmentationmemory_reserved, null)
    rdb_backup_enabled              = try(var.redis_configuration.rdb_backup_enabled, false)
    rdb_backup_frequency            = try(var.redis_configuration.rdb_backup_frequency, null)
    rdb_backup_max_snapshot_count   = try(var.redis_configuration.rdb_backup_max_snapshot_count, null)
    rdb_storage_connection_string   = try(var.redis_configuration.rdb_storage_connection_string, null)
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedules
    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = try(patch_schedule.value.maintenance_window, "PT5H")
    }
  }
}

resource "azurerm_redis_firewall_rule" "rules" {
  for_each = var.firewall_rules

  name                = each.key
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}
