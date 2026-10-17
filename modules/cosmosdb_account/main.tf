resource "azurerm_cosmosdb_account" "account" {
  name                                  = var.name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  offer_type                            = var.offer_type
  kind                                  = var.kind
  automatic_failover_enabled            = var.automatic_failover_enabled
  free_tier_enabled                     = var.free_tier_enabled
  public_network_access_enabled         = var.public_network_access_enabled
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  ip_range_filter                       = length(var.ip_range_filter) > 0 ? var.ip_range_filter : null
  tags                                  = var.tags

  consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = length(var.geo_locations) > 0 ? var.geo_locations : [
      {
        location          = var.location
        failover_priority = 0
        zone_redundant    = false
      }
    ]
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, false)
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = backup.value.type
      interval_in_minutes = try(backup.value.interval_in_minutes, 240)
      retention_in_hours  = try(backup.value.retention_in_hours, 8)
      storage_redundancy  = try(backup.value.storage_redundancy, "Geo")
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }
}

resource "azurerm_cosmosdb_sql_database" "databases" {
  for_each = var.sql_databases

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
  throughput          = each.value.max_throughput == null ? each.value.throughput : null

  dynamic "autoscale_settings" {
    for_each = each.value.max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_sql_container" "containers" {
  for_each = var.sql_containers

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
  database_name       = each.value.database_name
  partition_key_paths = each.value.partition_key_paths
  throughput          = each.value.max_throughput == null ? each.value.throughput : null
  default_ttl         = each.value.default_ttl

  dynamic "autoscale_settings" {
    for_each = each.value.max_throughput != null ? [1] : []
    content {
      max_throughput = each.value.max_throughput
    }
  }

  depends_on = [azurerm_cosmosdb_sql_database.databases]
}
