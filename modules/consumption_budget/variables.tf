variable "name" {
  description = "(Required) The name which should be used for this Consumption Budget. Changing this forces a new resource to be created."
  type        = string
}

variable "scope_type" {
  description = "(Optional) The scope type for the budget: 'subscription' or 'resource_group'. Defaults to 'subscription'."
  type        = string
  default     = "subscription"

  validation {
    condition     = contains(["subscription", "resource_group"], var.scope_type)
    error_message = "scope_type must be either 'subscription' or 'resource_group'."
  }
}

variable "subscription_id" {
  description = "(Optional) The ID of the Subscription to apply the budget to. Required when scope_type is 'subscription'."
  type        = string
  default     = null
}

variable "resource_group_id" {
  description = "(Optional) The ID of the Resource Group to apply the budget to. Required when scope_type is 'resource_group'."
  type        = string
  default     = null
}

variable "amount" {
  description = "(Required) The total amount of cost to track with the budget."
  type        = number
}

variable "time_grain" {
  description = "(Optional) The time covered by a budget. Tracking of the amount will be reset based on the time grain. Must be one of 'Monthly', 'Quarterly', 'Annually', or 'BillingMonth'. Defaults to 'Monthly'."
  type        = string
  default     = "Monthly"
}

variable "time_period" {
  description = "(Required) The time period for the budget."
  type = object({
    start_date = string # YYYY-MM-01T00:00:00Z format
    end_date   = optional(string)
  })
}

variable "notifications" {
  description = "(Required) Map of notifications to send when threshold conditions are met."
  type = map(object({
    operator       = string                     # "EqualTo", "GreaterThan", "GreaterThanOrEqualTo"
    threshold      = number                     # percentage (e.g. 50, 80, 100)
    threshold_type = optional(string, "Actual") # "Actual" or "Forecasted"
    contact_emails = optional(list(string), [])
    contact_roles  = optional(list(string), ["Owner", "Contributor"])
    contact_groups = optional(list(string), [])
  }))
  default = {}
}
