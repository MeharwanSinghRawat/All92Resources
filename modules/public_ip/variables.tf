variable "name" {
  description = "Specifies the name of the Public IP. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Public IP."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure region where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Standard SKU requires Static."
  type        = string
  default     = "Static"
  validation {
    condition     = contains(["Static", "Dynamic"], var.allocation_method)
    error_message = "allocation_method must be either 'Static' or 'Dynamic'."
  }
}

variable "sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "sku must be either 'Basic' or 'Standard'."
  }
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for the Public IP. Possible values are Regional and Global. Defaults to Regional."
  type        = string
  default     = "Regional"
}

variable "zones" {
  description = "A collection containing the availability zone(s) to allocate the Public IP in (e.g. ['1', '2', '3'] for zone-redundant)."
  type        = list(string)
  default     = []
}

variable "ip_version" {
  description = "The IP Version to use, IPv6 or IPv4. Defaults to IPv4."
  type        = string
  default     = "IPv4"
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN: <label>.<region>.cloudapp.azure.com."
  type        = string
  default     = null
}

variable "reverse_fqdn" {
  description = "A fully qualified domain name that resolves to this public IP address for PTR lookup."
  type        = string
  default     = null
}

variable "idle_timeout_in_minutes" {
  description = "Specifies the timeout for the TCP idle connection in minutes. Range from 4 to 30. Defaults to 4."
  type        = number
  default     = 4
}

variable "public_ip_prefix_id" {
  description = "If specified then public IP address allocated will be provided from the given Public IP prefix."
  type        = string
  default     = null
}

variable "ddos_protection_mode" {
  description = "The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited."
  type        = string
  default     = "VirtualNetworkInherited"
}

variable "ddos_protection_plan_id" {
  description = "The ID of DDoS protection plan associated with the public IP (only applicable if ddos_protection_mode is Enabled)."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
