variable "name" {
  description = "(Required) Specifies the name of the Virtual WAN."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Virtual WAN is created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "type" {
  description = "(Optional) Specifies the type of Virtual WAN. Possible values are 'Basic' and 'Standard'. Defaults to 'Standard'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.type)
    error_message = "type must be either 'Basic' or 'Standard'."
  }
}

variable "disable_vpn_encryption" {
  description = "(Optional) Boolean flag to specify when Virtual WAN should disable VPN encryption. Defaults to false."
  type        = bool
  default     = false
}

variable "allow_branch_to_branch_traffic" {
  description = "(Optional) Boolean flag to specify when Virtual WAN allows branch to branch traffic. Defaults to true."
  type        = bool
  default     = true
}

variable "office365_local_breakout_category" {
  description = "(Optional) Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to 'None'."
  type        = string
  default     = "None"
}

variable "virtual_hubs" {
  description = "(Optional) Map of Virtual Hubs to create within this Virtual WAN."
  type = map(object({
    location       = string
    address_prefix = string
    sku            = optional(string, "Standard")
    routes = optional(list(object({
      address_prefixes    = list(string)
      next_hop_ip_address = string
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "hub_connections" {
  description = "(Optional) Map of Virtual Hub connections linking spoke VNets to hubs."
  type = map(object({
    virtual_hub_name          = string
    remote_virtual_network_id = string
    internet_security_enabled = optional(bool, false)
    routing = optional(object({
      associated_route_table_id = optional(string, null)
      propagated_route_table = optional(object({
        labels          = optional(list(string), [])
        route_table_ids = optional(list(string), [])
      }), null)
    }), null)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
