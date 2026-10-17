resource "azurerm_storage_account" "storage" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  min_tls_version                 = var.min_tls_version
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  is_hns_enabled                  = var.is_hns_enabled

  blob_properties {
    versioning_enabled = var.blob_versioning_enabled

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      ip_rules                   = try(network_rules.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, [])
      bypass                     = try(network_rules.value.bypass, ["AzureServices"])
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each = var.containers

  name                  = coalesce(each.value.name, each.key)
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = try(each.value.container_access_type, "private")
  metadata              = try(each.value.metadata, {})
}

resource "azurerm_storage_share" "file_shares" {
  for_each = var.file_shares

  name               = coalesce(each.value.name, each.key)
  storage_account_id = azurerm_storage_account.storage.id
  quota              = try(each.value.quota, 50)
}
