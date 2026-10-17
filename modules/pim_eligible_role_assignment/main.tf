resource "azurerm_pim_eligible_role_assignment" "assignment" {
  scope              = var.scope
  role_definition_id = var.role_definition_id
  principal_id       = var.principal_id
  justification      = var.justification
  condition          = var.condition
  condition_version  = var.condition_version

  dynamic "schedule" {
    for_each = var.schedule != null ? [var.schedule] : []
    content {
      start_date_time = schedule.value.start_date_time

      dynamic "expiration" {
        for_each = schedule.value.expiration != null ? [schedule.value.expiration] : []
        content {
          duration_hours = expiration.value.duration_hours
          duration_days  = expiration.value.duration_days
          end_date_time  = expiration.value.end_date_time
        }
      }
    }
  }

  dynamic "ticket" {
    for_each = var.ticket != null ? [var.ticket] : []
    content {
      number = ticket.value.number
      system = ticket.value.system
    }
  }
}
