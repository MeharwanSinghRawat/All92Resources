variable "name" {
  description = "(Required) Specifies the name of the App Service Plan (Server Farm). Must be between 1 and 60 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 60 && can(regex("^[a-zA-Z0-9-][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name))
    error_message = "App Service Plan name must be between 1 and 60 characters and contain only alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the App Service Plan resides."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the App Service Plan will be created."
  type        = string
}

variable "os_type" {
  description = "(Required) The O/S type for the App Services to be hosted in this plan. Possible values include 'Linux' and 'Windows'."
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be either 'Linux' or 'Windows'."
  }
}

variable "sku_name" {
  description = "(Required) The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, WS1, WS2, WS3, Y1, EP1, EP2, EP3."
  type        = string
  default     = "B1"
}

variable "worker_count" {
  description = "(Optional) The number of Workers (instances) for this App Service Plan. Defaults to null."
  type        = number
  default     = null
}

variable "maximum_elastic_worker_count" {
  description = "(Optional) The maximum number of workers to use with an Elastic SKU Plan. Defaults to null."
  type        = number
  default     = null
}

variable "zone_balancing_enabled" {
  description = "(Optional) Should Zone Balancing be enabled for the App Service Plan? Requires Premium SKU. Defaults to false."
  type        = bool
  default     = false
}

variable "per_site_scaling_enabled" {
  description = "(Optional) Should Per Site Scaling be enabled for this plan? Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the App Service Plan."
  type        = map(string)
  default     = {}
}
