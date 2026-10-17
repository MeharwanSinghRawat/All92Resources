variable "name" {
  description = "(Required) The name of the Metric Alert. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Metric Alert."
  type        = string
}

variable "scopes" {
  description = "(Required) A set of strings of resource IDs at which the metric criteria should be applied."
  type        = list(string)
}

variable "description" {
  description = "(Optional) The description of this Metric Alert."
  type        = string
  default     = null
}

variable "severity" {
  description = "(Optional) The severity of this Metric Alert. Possible values are 0 (critical), 1 (error), 2 (warning), 3 (informational), and 4 (verbose). Defaults to 2."
  type        = number
  default     = 2

  validation {
    condition     = contains([0, 1, 2, 3, 4], var.severity)
    error_message = "Severity must be between 0 and 4."
  }
}

variable "frequency" {
  description = "(Optional) The evaluation frequency of this Metric Alert. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M."
  type        = string
  default     = "PT1M"
}

variable "window_size" {
  description = "(Optional) The period of time that is used to monitor alert activity. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M."
  type        = string
  default     = "PT5M"
}

variable "enabled" {
  description = "(Optional) Should this Metric Alert be enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "auto_mitigate" {
  description = "(Optional) Should the alerts in this Metric Alert be auto resolved? Defaults to true."
  type        = bool
  default     = true
}

variable "target_resource_type" {
  description = "(Optional) The resource type (e.g. 'Microsoft.Compute/virtualMachines') of the target resources."
  type        = string
  default     = null
}

variable "target_resource_location" {
  description = "(Optional) The location of the target resources."
  type        = string
  default     = null
}

variable "criteria" {
  description = "(Optional) Static metric criteria list for the alert."
  type = list(object({
    metric_namespace       = string
    metric_name            = string
    aggregation            = string
    operator               = string
    threshold              = number
    skip_metric_validation = optional(bool, false)
    dimensions = optional(list(object({
      name     = string
      operator = string
      values   = list(string)
    })), [])
  }))
  default = []
}

variable "dynamic_criteria" {
  description = "(Optional) Dynamic metric criteria block using Machine Learning anomaly detection."
  type = object({
    metric_namespace         = string
    metric_name              = string
    aggregation              = string
    operator                 = string
    alert_sensitivity        = string
    evaluation_total_count   = optional(number, 4)
    evaluation_failure_count = optional(number, 4)
    ignore_data_before       = optional(string, null)
    skip_metric_validation   = optional(bool, false)
    dimensions = optional(list(object({
      name     = string
      operator = string
      values   = list(string)
    })), [])
  })
  default = null
}

variable "action_group_ids" {
  description = "(Optional) List of Monitor Action Group IDs to trigger when the alert fires."
  type        = list(string)
  default     = []
}

variable "webhook_properties" {
  description = "(Optional) Key-value pairs of properties to send with the alert action payload."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
