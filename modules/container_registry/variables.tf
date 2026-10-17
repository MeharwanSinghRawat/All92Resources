variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Only alphanumeric characters allowed, 5-50 characters, globally unique."
  type        = string

  validation {
    condition     = length(var.name) >= 5 && length(var.name) <= 50 && can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "Container Registry name must be 5 to 50 characters long and contain only alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry."
  type        = string
}

variable "location" {
  description = "(Required) Supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Optional) The SKU name of the container registry. Possible values are 'Basic', 'Standard' and 'Premium'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku must be one of 'Basic', 'Standard', or 'Premium'."
  }
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is enabled for the container registry. Defaults to true."
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry. Requires Premium SKU."
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "network_rule_set" {
  description = "(Optional) Network rule set for Container Registry (Premium SKU only)."
  type = object({
    default_action = optional(string, "Allow")
    ip_rules       = optional(list(string), [])
  })
  default = null
}

variable "georeplications" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated (Premium SKU only)."
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
    tags                    = optional(map(string), {})
  }))
  default = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
