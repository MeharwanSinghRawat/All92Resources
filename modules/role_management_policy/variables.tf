variable "scope" {
  description = "(Required) The scope at which the Role Management Policy applies to. Must be a management group, subscription, or resource group ID."
  type        = string
}

variable "role_definition_id" {
  description = "(Required) The Scoped-ID or ID of the Role Definition."
  type        = string
}

variable "activation_rules" {
  description = "(Optional) Settings for activating eligible assignments."
  type = object({
    maximum_duration                                   = optional(string)
    require_approval                                   = optional(bool)
    require_justification                              = optional(bool)
    require_multifactor_authentication                 = optional(bool)
    require_ticket_info                                = optional(bool)
    required_conditional_access_authentication_context = optional(string)
    approval_stage = optional(object({
      primary_approver = list(object({
        object_id = string
        type      = string # "User" or "Group"
      }))
    }))
  })
  default = null
}

variable "active_assignment_rules" {
  description = "(Optional) Settings for active/permanent role assignments."
  type = object({
    expiration_required                = optional(bool)
    expire_after                       = optional(string)
    require_justification              = optional(bool)
    require_multifactor_authentication = optional(bool)
    require_ticket_info                = optional(bool)
  })
  default = null
}

variable "eligible_assignment_rules" {
  description = "(Optional) Settings for eligible role assignments."
  type = object({
    expiration_required = optional(bool)
    expire_after        = optional(string)
  })
  default = null
}

variable "notification_rules" {
  description = "(Optional) Notification rules for role activations and assignments."
  type = object({
    active_assignments = optional(object({
      admin_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      approver_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      assignee_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
    }))
    eligible_activations = optional(object({
      admin_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      approver_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      assignee_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
    }))
    eligible_assignments = optional(object({
      admin_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      approver_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
      assignee_notifications = optional(object({
        additional_recipients = optional(list(string))
        default_recipients    = bool
        notification_level    = string
      }))
    }))
  })
  default = null
}
