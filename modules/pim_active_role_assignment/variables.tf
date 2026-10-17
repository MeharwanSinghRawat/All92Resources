variable "scope" {
  description = "(Required) The scope at which the PIM Active Role Assignment applies to (e.g. a subscription ID, resource group ID, or specific resource ID)."
  type        = string
}

variable "role_definition_id" {
  description = "(Required) The Scoped-ID of the Role Definition."
  type        = string
}

variable "principal_id" {
  description = "(Required) The ID of the Principal to assign the active PIM role to."
  type        = string
}

variable "justification" {
  description = "(Optional) The justification for the role assignment."
  type        = string
  default     = null
}

variable "schedule" {
  description = "(Optional) Schedule configuration for the PIM active role assignment."
  type = object({
    start_date_time = optional(string)
    expiration = optional(object({
      duration_hours = optional(number)
      duration_days  = optional(number)
      end_date_time  = optional(string)
    }))
  })
  default = null
}

variable "ticket" {
  description = "(Optional) Ticket information for audit compliance."
  type = object({
    number = optional(string)
    system = optional(string)
  })
  default = null
}
