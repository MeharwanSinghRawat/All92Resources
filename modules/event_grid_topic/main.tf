resource "azurerm_eventgrid_topic" "topic" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  input_schema                  = var.input_schema
  public_network_access_enabled = var.public_network_access_enabled
  local_auth_enabled            = var.local_auth_enabled
  tags                          = var.tags

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  dynamic "inbound_ip_rule" {
    for_each = var.inbound_ip_rules
    content {
      ip_mask = inbound_ip_rule.value.ip_mask
      action  = try(inbound_ip_rule.value.action, "Allow")
    }
  }
}

resource "azurerm_eventgrid_event_subscription" "subscriptions" {
  for_each = var.subscriptions

  name                  = each.key
  scope                 = azurerm_eventgrid_topic.topic.id
  event_delivery_schema = each.value.event_delivery_schema

  dynamic "webhook_endpoint" {
    for_each = each.value.webhook_endpoint != null ? [each.value.webhook_endpoint] : []
    content {
      url                               = webhook_endpoint.value.url
      max_events_per_batch              = webhook_endpoint.value.max_events_per_batch
      preferred_batch_size_in_kilobytes = webhook_endpoint.value.preferred_batch_size_in_kilobytes
      active_directory_tenant_id        = webhook_endpoint.value.active_directory_tenant_id
      active_directory_app_id_or_uri    = webhook_endpoint.value.active_directory_app_id_or_uri
    }
  }

  dynamic "azure_function_endpoint" {
    for_each = each.value.azure_function_endpoint != null ? [each.value.azure_function_endpoint] : []
    content {
      function_id                       = azure_function_endpoint.value.function_id
      max_events_per_batch              = azure_function_endpoint.value.max_events_per_batch
      preferred_batch_size_in_kilobytes = azure_function_endpoint.value.preferred_batch_size_in_kilobytes
    }
  }

  service_bus_queue_endpoint_id = each.value.service_bus_queue_endpoint_id
  service_bus_topic_endpoint_id = each.value.service_bus_topic_endpoint_id
  eventhub_endpoint_id          = each.value.eventhub_endpoint_id
  included_event_types          = length(each.value.included_event_types) > 0 ? each.value.included_event_types : null

  dynamic "retry_policy" {
    for_each = each.value.retry_policy != null ? [each.value.retry_policy] : []
    content {
      max_delivery_attempts = retry_policy.value.max_delivery_attempts
      event_time_to_live    = retry_policy.value.event_time_to_live_in_minutes
    }
  }

  dynamic "subject_filter" {
    for_each = each.value.subject_filter != null ? [each.value.subject_filter] : []
    content {
      subject_begins_with = subject_filter.value.subject_begins_with
      subject_ends_with   = subject_filter.value.subject_ends_with
      case_sensitive      = subject_filter.value.case_sensitive
    }
  }
}
