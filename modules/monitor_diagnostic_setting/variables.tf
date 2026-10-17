variable "name" {
  description = "(Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created."
  type        = string
}

variable "target_resource_id" {
  description = "(Required) The ID of an existing Resource on which to configure Diagnostic Settings."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "(Optional) The ID of the Storage Account where logs should be sent."
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "(Optional) Specifies the ID of an Event Hub Authorization Rule where Logs should be sent."
  type        = string
  default     = null
}

variable "eventhub_name" {
  description = "(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent."
  type        = string
  default     = null
}

variable "partner_solution_id" {
  description = "(Optional) The ID of the market partner solution to be used as a destination."
  type        = string
  default     = null
}

variable "log_analytics_destination_type" {
  description = "(Optional) When set to 'Dedicated', logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  type        = string
  default     = null
}

variable "enabled_log_category_groups" {
  description = "(Optional) List of log category groups to enable (e.g. ['allLogs'] or ['audit']). Defaults to ['allLogs']."
  type        = list(string)
  default     = ["allLogs"]
}

variable "enabled_log_categories" {
  description = "(Optional) List of specific log categories to enable."
  type        = list(string)
  default     = []
}

variable "metric_categories" {
  description = "(Optional) List of metric categories to enable (e.g. ['AllMetrics']). Defaults to ['AllMetrics']."
  type        = list(string)
  default     = ["AllMetrics"]
}
