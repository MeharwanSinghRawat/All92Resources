resource "azurerm_subscription_policy_assignment" "sub_assignment" {
  count = var.scope_type == "subscription" ? 1 : 0

  name                 = var.name
  subscription_id      = var.subscription_id
  policy_definition_id = var.policy_definition_id
  display_name         = var.display_name
  description          = var.description
  enforce              = var.enforce
  parameters           = var.parameters
  location             = var.location

  dynamic "identity" {
    for_each = var.identity_type != null ? [var.identity_type] : []
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  dynamic "non_compliance_message" {
    for_each = var.non_compliance_messages
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id
    }
  }
}

resource "azurerm_resource_group_policy_assignment" "rg_assignment" {
  count = var.scope_type == "resource_group" ? 1 : 0

  name                 = var.name
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id
  display_name         = var.display_name
  description          = var.description
  enforce              = var.enforce
  parameters           = var.parameters
  location             = var.location

  dynamic "identity" {
    for_each = var.identity_type != null ? [var.identity_type] : []
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  dynamic "non_compliance_message" {
    for_each = var.non_compliance_messages
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id
    }
  }
}
