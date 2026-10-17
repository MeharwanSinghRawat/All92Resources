variable "name" {
  description = "(Required) Specifies the name of the NAT Gateway. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the NAT Gateway should exist."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the NAT Gateway should exist."
  type        = string
}

variable "sku_name" {
  description = "(Optional) The SKU which should be used. At this time the only supported value is 'Standard'. Defaults to 'Standard'."
  type        = string
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  description = "(Optional) The idle timeout which should be used in minutes. Valid values are between 4 and 120. Defaults to 4."
  type        = number
  default     = 4

  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 120
    error_message = "idle_timeout_in_minutes must be between 4 and 120."
  }
}

variable "zones" {
  description = "(Optional) A list of Availability Zones in which this NAT Gateway should be located."
  type        = list(string)
  default     = null
}

variable "public_ip_address_ids" {
  description = "(Optional) List of Public IP Address IDs to associate with this NAT Gateway."
  type        = list(string)
  default     = []
}

variable "public_ip_prefix_ids" {
  description = "(Optional) List of Public IP Prefix IDs to associate with this NAT Gateway."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "(Optional) Map of Subnet IDs to associate with this NAT Gateway."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
