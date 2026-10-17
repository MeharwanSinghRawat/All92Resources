variable "name" {
  description = "(Required) The name of the Network Security Group."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 80 && can(regex("^[a-zA-Z0-9._\\-]+$", var.name))
    error_message = "The Network Security Group name must be between 1 and 80 characters, and can only contain alphanumeric characters, underscores, hyphens, and periods."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Network Security Group will reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Network Security Group will be created."
  type        = string
}

variable "security_rules" {
  description = "(Optional) Map of security rules to configure for this Network Security Group."
  type = map(object({
    name                                       = optional(string)
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    description                                = optional(string)
  }))
  default = {}
}

variable "subnet_associations" {
  description = "(Optional) Map of subnet resource IDs to associate with this Network Security Group."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Network Security Group."
  type        = map(string)
  default     = {}
}
