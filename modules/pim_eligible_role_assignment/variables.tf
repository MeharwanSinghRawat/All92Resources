variable "scope" {
  description = "(Required) The scope at which the PIM Eligible Role Assignment applies to."
  type        = string
}

variable "role_definition_id" {
  description = "(Required) The Scoped-ID of the Role Definition."
  type        = string
}

variable "principal_id" {
  description = "(Required) The ID of the Principal to make eligible for the role."
  type        = string
}

variable "justification" {
  description = "(Optional) The justification for making the principal eligible."
  type        = string
  default     = null
}

variable "schedule" {
  description = "(Optional) Schedule configuration for the eligibility window."
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

variable "condition" {
  description = "(Optional) Attribute-based access control condition for the role."
  type        = string
  default     = null
}

variable "condition_version" {
  description = "(Optional) Version of the condition (e.g. '2.0')."
  type        = string
  default     = null
}
