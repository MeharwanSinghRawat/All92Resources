variable "name" {
  description = "(Required) The name of the Azure Firewall."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 80
    error_message = "Azure Firewall name must be between 1 and 80 characters."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Azure Firewall should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Azure Firewall will be created."
  type        = string
}

variable "sku_name" {
  description = "(Optional) SKU name of the Azure Firewall. Possible values are 'AZFW_VNet' and 'AZFW_Hub'."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition     = contains(["AZFW_VNet", "AZFW_Hub"], var.sku_name)
    error_message = "sku_name must be either 'AZFW_VNet' or 'AZFW_Hub'."
  }
}

variable "sku_tier" {
  description = "(Optional) SKU tier of the Azure Firewall. Possible values are 'Basic', 'Standard', and 'Premium'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be 'Basic', 'Standard', or 'Premium'."
  }
}

variable "subnet_id" {
  description = "(Required) The resource ID of the AzureFirewallSubnet."
  type        = string
}

variable "management_subnet_id" {
  description = "(Optional) The resource ID of the AzureFirewallManagementSubnet (Required for Basic SKU)."
  type        = string
  default     = null
}

variable "zones" {
  description = "(Optional) A list of Availability Zones for Azure Firewall."
  type        = list(string)
  default     = []
}

variable "public_ip_id" {
  description = "(Required) The ID of the Public IP Address to attach to the Azure Firewall."
  type        = string
}

variable "public_ip_address" {
  description = "(Optional) The Public IP address string, used in NAT rule collections if destination_address is not explicitly set."
  type        = string
  default     = null
}

variable "management_public_ip_id" {
  description = "(Optional) Public IP ID for AzureFirewallManagementSubnet (Required if sku_tier is 'Basic')."
  type        = string
  default     = null
}

variable "threat_intel_mode" {
  description = "(Optional) The threat intelligence mode for the Firewall / Policy. Possible values: 'Alert', 'Deny', 'Off'."
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.threat_intel_mode)
    error_message = "threat_intel_mode must be 'Alert', 'Deny', or 'Off'."
  }
}

variable "dns_proxy_enabled" {
  description = "(Optional) Whether to enable DNS proxy on the Firewall Policy."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "(Optional) A list of custom DNS servers for the Firewall Policy."
  type        = list(string)
  default     = []
}

variable "create_firewall_policy" {
  description = "(Optional) Whether to create and attach a dedicated Azure Firewall Policy."
  type        = bool
  default     = true
}

variable "firewall_policy_id" {
  description = "(Optional) Existing Firewall Policy ID if create_firewall_policy is false."
  type        = string
  default     = null
}

variable "network_rule_collections" {
  description = "(Optional) Map of network rule collections to define on the firewall policy."
  type = map(object({
    priority = number
    action   = string # "Allow" or "Deny"
    rules = map(object({
      protocols             = list(string) # "TCP", "UDP", "ICMP", "Any"
      destination_ports     = list(string)
      source_addresses      = optional(list(string), [])
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
    }))
  }))
  default = {}
}

variable "application_rule_collections" {
  description = "(Optional) Map of application rule collections to define on the firewall policy."
  type = map(object({
    priority = number
    action   = string # "Allow" or "Deny"
    rules = map(object({
      source_addresses  = optional(list(string), [])
      destination_fqdns = optional(list(string), [])
      protocols = optional(list(object({
        port = number
        type = string # "Http" or "Https"
        })), [
        {
          port = 443
          type = "Https"
        },
        {
          port = 80
          type = "Http"
        }
      ])
    }))
  }))
  default = {}
}

variable "nat_rule_collections" {
  description = "(Optional) Map of DNAT rule collections to define on the firewall policy."
  type = map(object({
    priority = number
    action   = string # "Dnat"
    rules = map(object({
      protocols           = list(string)
      source_addresses    = list(string)
      destination_address = optional(string, null)
      destination_ports   = list(string)
      translated_address  = string
      translated_port     = number
    }))
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Azure Firewall resources."
  type        = map(string)
  default     = {}
}
