variable "name" {
  description = "(Required) Specifies the name of the Load Balancer. Must be between 1 and 80 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 80 && can(regex("^[a-zA-Z0-9-_.()]+$", var.name))
    error_message = "Load Balancer name must be between 1 and 80 characters and can only contain alphanumeric characters, underscores, hyphens, periods, and parentheses."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Load Balancer resides."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Load Balancer will be created."
  type        = string
}

variable "sku" {
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are 'Basic', 'Standard', and 'Gateway'. Defaults to 'Standard'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Gateway"], var.sku)
    error_message = "sku must be one of: 'Basic', 'Standard', 'Gateway'."
  }
}

variable "sku_tier" {
  description = "(Optional) The SKU tier of this Load Balancer. Possible values are 'Global' and 'Regional'. Defaults to 'Regional'."
  type        = string
  default     = "Regional"

  validation {
    condition     = contains(["Global", "Regional"], var.sku_tier)
    error_message = "sku_tier must be either 'Global' or 'Regional'."
  }
}

variable "frontend_ip_configurations" {
  description = "(Required) Map of Frontend IP configurations for the Load Balancer. Can be Public (using public_ip_address_id) or Internal (using subnet_id)."
  type = map(object({
    name                          = optional(string)
    public_ip_address_id          = optional(string, null)
    subnet_id                     = optional(string, null)
    private_ip_address            = optional(string, null)
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address_version    = optional(string, "IPv4")
    zones                         = optional(list(string), null)
  }))

  validation {
    condition     = length(var.frontend_ip_configurations) >= 1
    error_message = "At least one frontend_ip_configuration must be provided."
  }
}

variable "backend_address_pools" {
  description = "(Optional) Map of Backend Address Pools to create for the Load Balancer."
  type = map(object({
    name = optional(string)
  }))
  default = {}
}

variable "probes" {
  description = "(Optional) Map of Health Probes to monitor backend endpoints."
  type = map(object({
    name                = optional(string)
    protocol            = optional(string, "Tcp")
    port                = number
    request_path        = optional(string, null)
    interval_in_seconds = optional(number, 15)
    number_of_probes    = optional(number, 2)
    probe_threshold     = optional(number, 1)
  }))
  default = {}
}

variable "load_balancing_rules" {
  description = "(Optional) Map of Load Balancing Rules to distribute traffic from frontends to backends."
  type = map(object({
    name                           = optional(string)
    frontend_ip_configuration_name = string
    backend_address_pool_name      = optional(string, null)
    probe_name                     = optional(string, null)
    protocol                       = optional(string, "Tcp")
    frontend_port                  = number
    backend_port                   = number
    enable_floating_ip             = optional(bool, false)
    idle_timeout_in_minutes        = optional(number, 4)
    load_distribution              = optional(string, "Default")
    enable_tcp_reset               = optional(bool, false)
    disable_outbound_snat          = optional(bool, false)
  }))
  default = {}
}

variable "inbound_nat_rules" {
  description = "(Optional) Map of Inbound NAT Rules for direct port routing (e.g., SSH, RDP)."
  type = map(object({
    name                           = optional(string)
    frontend_ip_configuration_name = string
    protocol                       = optional(string, "Tcp")
    frontend_port                  = number
    backend_port                   = number
    idle_timeout_in_minutes        = optional(number, 4)
    enable_floating_ip             = optional(bool, false)
    enable_tcp_reset               = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
}
