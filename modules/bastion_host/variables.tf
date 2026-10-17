variable "name" {
  description = "(Required) Specifies the name of the Bastion Host. Must be between 1 and 80 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 80 && can(regex("^[a-zA-Z0-9._\\-]+$", var.name))
    error_message = "Bastion Host name must be between 1 and 80 characters, and can only contain alphanumeric characters, hyphens, periods, and underscores."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Bastion Host resides."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Bastion Host will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the dedicated Subnet named 'AzureBastionSubnet' with at least a /26 prefix."
  type        = string
}

variable "public_ip_id" {
  description = "(Required) The ID of the Public IP Address to assign to the Bastion Host."
  type        = string
}

variable "ip_configuration_name" {
  description = "(Optional) The name of the IP configuration. Defaults to '<name>-ipconf'."
  type        = string
  default     = null
}

variable "sku" {
  description = "(Optional) The SKU tier of the Bastion Host. Possible values are 'Basic', 'Standard', and 'Premium'. Defaults to 'Standard'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The Bastion SKU must be one of: 'Basic', 'Standard', 'Premium'."
  }
}

variable "scale_units" {
  description = "(Optional) The number of scale units for the Bastion Host. Must be between 2 and 50. Only applicable for 'Standard' and 'Premium' SKUs. Defaults to 2."
  type        = number
  default     = 2

  validation {
    condition     = var.scale_units >= 2 && var.scale_units <= 50
    error_message = "scale_units must be between 2 and 50."
  }
}

variable "copy_paste_enabled" {
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host? Defaults to true."
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "(Optional) Is File Copy feature enabled? Requires 'Standard' or 'Premium' SKU. Defaults to true."
  type        = bool
  default     = true
}

variable "ip_connect_enabled" {
  description = "(Optional) Is IP Connect feature enabled? Allows connecting to targets via IP address. Requires 'Standard' or 'Premium' SKU. Defaults to true."
  type        = bool
  default     = true
}

variable "shareable_link_enabled" {
  description = "(Optional) Is Shareable Link feature enabled? Requires 'Standard' or 'Premium' SKU. Defaults to false."
  type        = bool
  default     = false
}

variable "tunneling_enabled" {
  description = "(Optional) Is Native Client (Tunneling) feature enabled? Allows SSH/RDP via native desktop client. Requires 'Standard' or 'Premium' SKU. Defaults to true."
  type        = bool
  default     = true
}

variable "session_recording_enabled" {
  description = "(Optional) Is Session Recording feature enabled? Requires 'Premium' SKU. Defaults to false."
  type        = bool
  default     = false
}

variable "kerberos_enabled" {
  description = "(Optional) Is Kerberos authentication enabled? Requires 'Standard' or 'Premium' SKU. Defaults to false."
  type        = bool
  default     = false
}

variable "zones" {
  description = "(Optional) Specifies a list of Availability Zones in which the Bastion Host and Public IP should be located."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
