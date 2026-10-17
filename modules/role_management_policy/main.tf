resource "azurerm_role_management_policy" "policy" {
  scope              = var.scope
  role_definition_id = var.role_definition_id

  dynamic "activation_rules" {
    for_each = var.activation_rules != null ? [var.activation_rules] : []
    content {
      maximum_duration                                   = activation_rules.value.maximum_duration
      require_approval                                   = activation_rules.value.require_approval
      require_justification                              = activation_rules.value.require_justification
      require_multifactor_authentication                 = activation_rules.value.require_multifactor_authentication
      require_ticket_info                                = activation_rules.value.require_ticket_info
      required_conditional_access_authentication_context = activation_rules.value.required_conditional_access_authentication_context

      dynamic "approval_stage" {
        for_each = activation_rules.value.approval_stage != null ? [activation_rules.value.approval_stage] : []
        content {
          dynamic "primary_approver" {
            for_each = approval_stage.value.primary_approver != null ? approval_stage.value.primary_approver : []
            content {
              object_id = primary_approver.value.object_id
              type      = primary_approver.value.type
            }
          }
        }
      }
    }
  }

  dynamic "active_assignment_rules" {
    for_each = var.active_assignment_rules != null ? [var.active_assignment_rules] : []
    content {
      expiration_required                = active_assignment_rules.value.expiration_required
      expire_after                       = active_assignment_rules.value.expire_after
      require_justification              = active_assignment_rules.value.require_justification
      require_multifactor_authentication = active_assignment_rules.value.require_multifactor_authentication
      require_ticket_info                = active_assignment_rules.value.require_ticket_info
    }
  }

  dynamic "eligible_assignment_rules" {
    for_each = var.eligible_assignment_rules != null ? [var.eligible_assignment_rules] : []
    content {
      expiration_required = eligible_assignment_rules.value.expiration_required
      expire_after        = eligible_assignment_rules.value.expire_after
    }
  }

  dynamic "notification_rules" {
    for_each = var.notification_rules != null ? [var.notification_rules] : []
    content {
      dynamic "active_assignments" {
        for_each = notification_rules.value.active_assignments != null ? [notification_rules.value.active_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = active_assignments.value.admin_notifications != null ? [active_assignments.value.admin_notifications] : []
            content {
              additional_recipients = admin_notifications.value.additional_recipients
              default_recipients    = admin_notifications.value.default_recipients
              notification_level    = admin_notifications.value.notification_level
            }
          }

          dynamic "approver_notifications" {
            for_each = active_assignments.value.approver_notifications != null ? [active_assignments.value.approver_notifications] : []
            content {
              additional_recipients = approver_notifications.value.additional_recipients
              default_recipients    = approver_notifications.value.default_recipients
              notification_level    = approver_notifications.value.notification_level
            }
          }

          dynamic "assignee_notifications" {
            for_each = active_assignments.value.assignee_notifications != null ? [active_assignments.value.assignee_notifications] : []
            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              default_recipients    = assignee_notifications.value.default_recipients
              notification_level    = assignee_notifications.value.notification_level
            }
          }
        }
      }

      dynamic "eligible_activations" {
        for_each = notification_rules.value.eligible_activations != null ? [notification_rules.value.eligible_activations] : []
        content {
          dynamic "admin_notifications" {
            for_each = eligible_activations.value.admin_notifications != null ? [eligible_activations.value.admin_notifications] : []
            content {
              additional_recipients = admin_notifications.value.additional_recipients
              default_recipients    = admin_notifications.value.default_recipients
              notification_level    = admin_notifications.value.notification_level
            }
          }

          dynamic "approver_notifications" {
            for_each = eligible_activations.value.approver_notifications != null ? [eligible_activations.value.approver_notifications] : []
            content {
              additional_recipients = approver_notifications.value.additional_recipients
              default_recipients    = approver_notifications.value.default_recipients
              notification_level    = approver_notifications.value.notification_level
            }
          }

          dynamic "assignee_notifications" {
            for_each = eligible_activations.value.assignee_notifications != null ? [eligible_activations.value.assignee_notifications] : []
            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              default_recipients    = assignee_notifications.value.default_recipients
              notification_level    = assignee_notifications.value.notification_level
            }
          }
        }
      }

      dynamic "eligible_assignments" {
        for_each = notification_rules.value.eligible_assignments != null ? [notification_rules.value.eligible_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = eligible_assignments.value.admin_notifications != null ? [eligible_assignments.value.admin_notifications] : []
            content {
              additional_recipients = eligible_assignments.value.additional_recipients
              default_recipients    = eligible_assignments.value.default_recipients
              notification_level    = eligible_assignments.value.notification_level
            }
          }

          dynamic "approver_notifications" {
            for_each = eligible_assignments.value.approver_notifications != null ? [eligible_assignments.value.approver_notifications] : []
            content {
              additional_recipients = approver_notifications.value.additional_recipients
              default_recipients    = approver_notifications.value.default_recipients
              notification_level    = approver_notifications.value.notification_level
            }
          }

          dynamic "assignee_notifications" {
            for_each = eligible_assignments.value.assignee_notifications != null ? [eligible_assignments.value.assignee_notifications] : []
            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              default_recipients    = assignee_notifications.value.default_recipients
              notification_level    = assignee_notifications.value.notification_level
            }
          }
        }
      }
    }
  }
}
