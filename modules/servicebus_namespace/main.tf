resource "azurerm_servicebus_namespace" "namespace" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  capacity                      = var.sku == "Premium" ? var.capacity : null
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
}

resource "azurerm_servicebus_queue" "queue" {
  for_each = var.queues

  name                                 = coalesce(each.value.name, each.key)
  namespace_id                         = azurerm_servicebus_namespace.namespace.id
  max_size_in_megabytes                = each.value.max_size_in_megabytes
  dead_lettering_on_message_expiration = each.value.dead_lettering_on_message_expiration
  default_message_ttl                  = each.value.default_message_ttl
  lock_duration                        = each.value.lock_duration
  max_delivery_count                   = each.value.max_delivery_count
  requires_session                     = each.value.requires_session
  requires_duplicate_detection         = each.value.requires_duplicate_detection
}

resource "azurerm_servicebus_topic" "topic" {
  for_each = var.sku != "Basic" ? var.topics : {}

  name                         = coalesce(each.value.name, each.key)
  namespace_id                 = azurerm_servicebus_namespace.namespace.id
  max_size_in_megabytes        = each.value.max_size_in_megabytes
  default_message_ttl          = each.value.default_message_ttl
  requires_duplicate_detection = each.value.requires_duplicate_detection
  support_ordering             = each.value.support_ordering
}
