resource "azurerm_recovery_services_vault" "vault" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = var.sku
  storage_mode_type            = var.storage_mode_type
  cross_region_restore_enabled = var.storage_mode_type == "GeoRedundant" ? var.cross_region_restore_enabled : false
  tags                         = var.tags
}

resource "azurerm_backup_policy_vm" "policy" {
  for_each = var.vm_backup_policies

  name                = coalesce(each.value.name, each.key)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  timezone            = each.value.timezone

  backup {
    frequency = each.value.frequency
    time      = each.value.time
  }

  retention_daily {
    count = each.value.retention_daily_count
  }

  dynamic "retention_weekly" {
    for_each = each.value.retention_weekly != null ? [each.value.retention_weekly] : []
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = each.value.retention_monthly != null ? [each.value.retention_monthly] : []
    content {
      count    = retention_monthly.value.count
      weekdays = retention_monthly.value.weekdays
      weeks    = retention_monthly.value.weeks
    }
  }
}
