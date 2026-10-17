variable "name" {
  description = "(Required) The name of the Virtual Network Gateway."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network Gateway."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region in which the Virtual Network Gateway should exist."
  type        = string
}

variable "type" {
  description = "(Required) The type of the Virtual Network Gateway. Valid options are 'Vpn' or 'ExpressRoute'."
  type        = string
  default     = "Vpn"

  validation {
    condition     = contains(["Vpn", "ExpressRoute"], var.type)
    error_message = "type must be either 'Vpn' or 'ExpressRoute'."
  }
}

variable "vpn_type" {
  description = "(Optional) The routing type of the Virtual Network Gateway. Valid options are 'RouteBased' or 'PolicyBased'. Defaults to 'RouteBased'."
  type        = string
  default     = "RouteBased"

  validation {
    condition     = contains(["RouteBased", "PolicyBased"], var.vpn_type)
    error_message = "vpn_type must be either 'RouteBased' or 'PolicyBased'."
  }
}

variable "sku" {
  description = "(Required) Configuration of the size and capacity of the virtual network gateway. (e.g. 'VpnGw1', 'VpnGw2', 'VpnGw1AZ', 'ErGw1AZ')."
  type        = string
  default     = "VpnGw1"
}

variable "generation" {
  description = "(Optional) The Generation of the Virtual Network gateway. Possible values include 'Generation1', 'Generation2' or 'None'. Defaults to 'Generation1'."
  type        = string
  default     = "Generation1"
}

variable "active_active" {
  description = "(Optional) If true, an active-active Virtual Network Gateway will be created. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_bgp" {
  description = "(Optional) If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false."
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "(Required) The ID of the GatewaySubnet in the Virtual Network where this Gateway will be deployed."
  type        = string
}

variable "public_ip_address_id" {
  description = "(Required) The ID of the Primary Public IP Address associated with the Virtual Network Gateway."
  type        = string
}

variable "secondary_public_ip_address_id" {
  description = "(Optional) The ID of the Secondary Public IP Address when active_active is true."
  type        = string
  default     = null
}

variable "bgp_settings" {
  description = "(Optional) BGP settings block for the Virtual Network Gateway."
  type = object({
    asn         = optional(number, 65515)
    peer_weight = optional(number, 0)
  })
  default = null
}

variable "vpn_client_configuration" {
  description = "(Optional) Point-to-Site VPN client configuration block."
  type = object({
    address_space        = list(string)
    vpn_client_protocols = optional(list(string), ["OpenVPN", "IkeV2"])
    root_certificate = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
  })
  default = null
}

variable "local_network_gateways" {
  description = "(Optional) Map of Local Network Gateways representing on-premises routers/firewalls."
  type = map(object({
    gateway_address = optional(string, null)
    gateway_fqdn    = optional(string, null)
    address_spaces  = optional(list(string), [])
    bgp_settings = optional(object({
      asn                 = number
      bgp_peering_address = string
      peer_weight         = optional(number, 0)
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "connections" {
  description = "(Optional) Map of Site-to-Site or VNet-to-VNet connections to establish."
  type = map(object({
    type                            = optional(string, "IPsec")
    local_network_gateway_name      = optional(string, null)
    peer_virtual_network_gateway_id = optional(string, null)
    shared_key                      = optional(string, null)
    enable_bgp                      = optional(bool, false)
    ipsec_policy = optional(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string
      sa_datasize      = optional(number, 102400000)
      sa_lifetime      = optional(number, 27000)
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
