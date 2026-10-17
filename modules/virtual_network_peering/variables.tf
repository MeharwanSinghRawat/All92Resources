variable "name" {
  description = "The name of the virtual network peering."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the local virtual network exists."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the local virtual network where this peering will be configured."
  type        = string
}

variable "remote_virtual_network_id" {
  description = "The full Azure resource ID of the remote virtual network."
  type        = string
  default     = null
}

variable "use_remote_vnet_data_source" {
  description = "Set to true to look up the remote virtual network via data block (data.azurerm_virtual_network). Ideal for cross-project setups where remote VNet is managed in a separate state."
  type        = bool
  default     = false
}

variable "remote_virtual_network_name" {
  description = "The name of the remote virtual network to peer with (used with data block lookup when use_remote_vnet_data_source is true)."
  type        = string
  default     = null
}

variable "remote_resource_group_name" {
  description = "The resource group of the remote virtual network (used with data block lookup). Defaults to resource_group_name if not specified."
  type        = string
  default     = null
}

variable "allow_virtual_network_access" {
  description = "Controls if the VMs in the local virtual network can access VMs in the remote virtual network. Defaults to true."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to true."
  type        = bool
  default     = true
}

variable "allow_gateway_transit" {
  description = "Controls gateway transit from local to remote. Must be false if no gateway exists in local VNet. Defaults to false."
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Controls whether remote gateways can be used on the local virtual network. Defaults to false."
  type        = bool
  default     = false
}
