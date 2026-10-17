resource "azurerm_monitor_action_group" "action_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name
  enabled             = var.enabled
  location            = var.location
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = email_receiver.value.use_common_alert_schema
    }
  }

  dynamic "sms_receiver" {
    for_each = var.sms_receivers
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.webhook_receivers
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = webhook_receiver.value.use_common_alert_schema

      dynamic "aad_auth" {
        for_each = webhook_receiver.value.aad_auth != null ? [webhook_receiver.value.aad_auth] : []
        content {
          object_id      = aad_auth.value.object_id
          identifier_uri = aad_auth.value.identifier_uri
          tenant_id      = aad_auth.value.tenant_id
        }
      }
    }
  }

  dynamic "arm_role_receiver" {
    for_each = var.arm_role_receivers
    content {
      name                    = arm_role_receiver.value.name
      role_id                 = arm_role_receiver.value.role_id
      use_common_alert_schema = arm_role_receiver.value.use_common_alert_schema
    }
  }

  dynamic "azure_app_push_receiver" {
    for_each = var.azure_app_push_receivers
    content {
      name          = azure_app_push_receiver.value.name
      email_address = azure_app_push_receiver.value.email_address
    }
  }

  dynamic "event_hub_receiver" {
    for_each = var.event_hub_receivers
    content {
      name                    = event_hub_receiver.value.name
      event_hub_namespace     = event_hub_receiver.value.event_hub_namespace
      event_hub_name          = event_hub_receiver.value.event_hub_name
      subscription_id         = event_hub_receiver.value.subscription_id
      use_common_alert_schema = event_hub_receiver.value.use_common_alert_schema
    }
  }

  dynamic "logic_app_receiver" {
    for_each = var.logic_app_receivers
    content {
      name                    = logic_app_receiver.value.name
      resource_id             = logic_app_receiver.value.resource_id
      callback_url            = logic_app_receiver.value.callback_url
      use_common_alert_schema = logic_app_receiver.value.use_common_alert_schema
    }
  }

  dynamic "azure_function_receiver" {
    for_each = var.azure_function_receivers
    content {
      name                     = azure_function_receiver.value.name
      function_app_resource_id = azure_function_receiver.value.function_app_resource_id
      function_name            = azure_function_receiver.value.function_name
      http_trigger_url         = azure_function_receiver.value.http_trigger_url
      use_common_alert_schema  = azure_function_receiver.value.use_common_alert_schema
    }
  }
}
