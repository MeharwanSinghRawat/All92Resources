resource "azurerm_consumption_budget_subscription" "sub_budget" {
  count = var.scope_type == "subscription" ? 1 : 0

  name            = var.name
  subscription_id = var.subscription_id
  amount          = var.amount
  time_grain      = var.time_grain

  time_period {
    start_date = var.time_period.start_date
    end_date   = var.time_period.end_date
  }

  dynamic "notification" {
    for_each = var.notifications
    content {
      operator       = notification.value.operator
      threshold      = notification.value.threshold
      threshold_type = notification.value.threshold_type
      contact_emails = notification.value.contact_emails
      contact_roles  = notification.value.contact_roles
      contact_groups = notification.value.contact_groups
    }
  }
}

resource "azurerm_consumption_budget_resource_group" "rg_budget" {
  count = var.scope_type == "resource_group" ? 1 : 0

  name              = var.name
  resource_group_id = var.resource_group_id
  amount            = var.amount
  time_grain        = var.time_grain

  time_period {
    start_date = var.time_period.start_date
    end_date   = var.time_period.end_date
  }

  dynamic "notification" {
    for_each = var.notifications
    content {
      operator       = notification.value.operator
      threshold      = notification.value.threshold
      threshold_type = notification.value.threshold_type
      contact_emails = notification.value.contact_emails
      contact_roles  = notification.value.contact_roles
      contact_groups = notification.value.contact_groups
    }
  }
}
