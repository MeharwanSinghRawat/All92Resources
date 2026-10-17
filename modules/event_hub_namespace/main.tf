resource "azurerm_eventhub_namespace" "namespace" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.capacity
  auto_inflate_enabled          = var.auto_inflate_enabled
  maximum_throughput_units      = var.auto_inflate_enabled ? var.maximum_throughput_units : null
  local_authentication_enabled  = var.local_authentication_enabled
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  dynamic "network_rulesets" {
    for_each = var.network_rulesets != null ? [var.network_rulesets] : []
    content {
      default_action                 = network_rulesets.value.default_action
      public_network_access_enabled  = network_rulesets.value.public_network_access_enabled
      trusted_service_access_enabled = network_rulesets.value.trusted_service_access_enabled

      dynamic "ip_rule" {
        for_each = network_rulesets.value.ip_rules
        content {
          ip_mask = ip_rule.value
          action  = "Allow"
        }
      }

      dynamic "virtual_network_rule" {
        for_each = network_rulesets.value.virtual_network_subnet_ids
        content {
          subnet_id                                       = virtual_network_rule.value
          ignore_missing_virtual_network_service_endpoint = false
        }
      }
    }
  }
}

resource "azurerm_eventhub" "hubs" {
  for_each = var.eventhubs

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  status              = each.value.status

  dynamic "capture_description" {
    for_each = each.value.capture_description != null ? [each.value.capture_description] : []
    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = capture_description.value.interval_in_seconds
      size_limit_in_bytes = capture_description.value.size_limit_in_bytes
      skip_empty_archives = capture_description.value.skip_empty_archives

      destination {
        name                = capture_description.value.destination.name
        archive_name_format = capture_description.value.destination.archive_name_format
        blob_container_name = capture_description.value.destination.blob_container_name
        storage_account_id  = capture_description.value.destination.storage_account_id
      }
    }
  }
}

resource "azurerm_eventhub_consumer_group" "consumer_groups" {
  for_each = var.consumer_groups

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = var.resource_group_name
  user_metadata       = each.value.user_metadata

  depends_on = [azurerm_eventhub.hubs]
}

resource "azurerm_eventhub_namespace_authorization_rule" "rules" {
  for_each = var.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}
