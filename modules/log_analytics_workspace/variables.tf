variable "name" {
  description = "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, numbers or hyphens."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Log Analytics workspace is created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018. Defaults to PerGB2018."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free SKU) or range between 30 and 730. Defaults to 30."
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if null."
  type        = number
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support ingestion over the public internet? Defaults to true."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support querying over the public internet? Defaults to true."
  type        = bool
  default     = true
}

variable "reservation_capacity_in_gb_per_day" {
  description = "(Optional) The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 50000."
  type        = number
  default     = null
}

variable "data_collection_rule_id" {
  description = "(Optional) The ID of the Data Collection Rule to use for this workspace."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
