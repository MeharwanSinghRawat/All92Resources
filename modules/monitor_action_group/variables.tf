variable "name" {
  description = "(Required) The name of the Monitor Action Group. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Action Group."
  type        = string
}

variable "short_name" {
  description = "(Required) The short name of the action group. Must not exceed 12 characters."
  type        = string

  validation {
    condition     = length(var.short_name) <= 12
    error_message = "The short_name cannot exceed 12 characters."
  }
}

variable "enabled" {
  description = "(Optional) Whether this action group is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "location" {
  description = "(Optional) The Azure Region where the Action Group should exist. Defaults to 'global'."
  type        = string
  default     = "global"
}

variable "email_receivers" {
  description = "(Optional) List of email receivers."
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "sms_receivers" {
  description = "(Optional) List of SMS receivers."
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default = []
}

variable "webhook_receivers" {
  description = "(Optional) List of Webhook receivers (e.g. for Slack, Teams, PagerDuty)."
  type = list(object({
    name                    = string
    service_uri             = string
    use_common_alert_schema = optional(bool, true)
    aad_auth = optional(object({
      object_id      = string
      identifier_uri = optional(string, null)
      tenant_id      = optional(string, null)
    }), null)
  }))
  default = []
}

variable "arm_role_receivers" {
  description = "(Optional) List of ARM role receivers."
  type = list(object({
    name                    = string
    role_id                 = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "azure_app_push_receivers" {
  description = "(Optional) List of Azure mobile app push receivers."
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "event_hub_receivers" {
  description = "(Optional) List of Event Hub receivers."
  type = list(object({
    name                    = string
    event_hub_id            = optional(string, null)
    event_hub_namespace     = optional(string, null)
    event_hub_name          = optional(string, null)
    subscription_id         = optional(string, null)
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "logic_app_receivers" {
  description = "(Optional) List of Logic App receivers."
  type = list(object({
    name                    = string
    resource_id             = string
    callback_url            = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "azure_function_receivers" {
  description = "(Optional) List of Azure Function receivers."
  type = list(object({
    name                     = string
    function_app_resource_id = string
    function_name            = string
    http_trigger_url         = string
    use_common_alert_schema  = optional(bool, true)
  }))
  default = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
