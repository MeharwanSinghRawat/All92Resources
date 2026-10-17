variable "name" {
  description = "(Required) The name of the Virtual Network."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 80 && can(regex("^[a-zA-Z0-9._\\-]+$", var.name))
    error_message = "The Virtual Network name must be between 1 and 80 characters, and can only contain alphanumeric characters, underscores, hyphens, and periods."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Virtual Network will reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Virtual Network will be created."
  type        = string
}

variable "address_space" {
  description = "(Required) The address space that is used by the Virtual Network in CIDR notation (e.g. ['10.0.0.0/16'])."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one CIDR block must be specified in address_space."
  }
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of custom DNS servers."
  type        = list(string)
  default     = []
}

variable "ddos_protection_plan" {
  description = "(Optional) Configuration for Azure DDoS Protection Plan."
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "subnets" {
  description = "(Optional) Map of subnets to create within the Virtual Network."
  type = map(object({
    name                                          = optional(string)
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string), [])
    service_endpoint_policy_ids                   = optional(list(string), [])
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    network_security_group_id                     = optional(string, null)
    route_table_id                                = optional(string, null)
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    })), [])
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Virtual Network."
  type        = map(string)
  default     = {}
}
