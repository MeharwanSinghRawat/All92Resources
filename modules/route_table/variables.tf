variable "name" {
  description = "(Required) The name of the Route Table. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the route table."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "bgp_route_propagation_enabled" {
  description = "(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. Defaults to true."
  type        = bool
  default     = true
}

variable "routes" {
  description = "(Optional) Map of custom routes to add to the route table."
  type = map(object({
    name                   = optional(string)
    address_prefix         = string
    next_hop_type          = string # VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None
    next_hop_in_ip_address = optional(string, null)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.routes : contains(["VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None"], v.next_hop_type)
    ])
    error_message = "next_hop_type must be one of: 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance', 'None'."
  }
}

variable "subnet_ids" {
  description = "(Optional) Map of subnet IDs to associate with this route table."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
