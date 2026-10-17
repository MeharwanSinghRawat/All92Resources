variable "name" {
  description = "(Required) Specifies the name of the Private Endpoint. Name must be 2-80 characters and contain only alphanumeric, underscores, and hyphens."
  type        = string

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 80 && can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "Private Endpoint name must be between 2 and 80 characters and contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group where the Private Endpoint should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Private Endpoint will be created."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
  type        = string
}

variable "target_resource_id" {
  description = "(Required) The ID of the target resource (e.g., Storage Account, Key Vault, Azure SQL) that the Private Endpoint will connect to."
  type        = string
}

variable "subresource_names" {
  description = "(Required) A list of subresource names which the Private Endpoint is able to connect to. (e.g., 'blob', 'file', 'vault', 'sqlServer')."
  type        = list(string)
}

variable "is_manual_connection" {
  description = "(Optional) Does the Private Endpoint require manual approval from the remote resource owner? Defaults to false."
  type        = bool
  default     = false
}

variable "request_message" {
  description = "(Optional) A message passed to the owner of the remote resource when the private endpoint requires manual approval."
  type        = string
  default     = null
}

variable "custom_network_interface_name" {
  description = "(Optional) The custom name of the network interface attached to the private endpoint."
  type        = string
  default     = null
}

variable "private_dns_zone_group" {
  description = "(Optional) Private DNS Zone Group configuration block to register the Private Endpoint DNS records."
  type = object({
    name                 = optional(string, "default")
    private_dns_zone_ids = list(string)
  })
  default = null
}

variable "ip_configurations" {
  description = "(Optional) List of static IP configurations for the private endpoint."
  type = list(object({
    name               = string
    private_ip_address = string
    subresource_name   = optional(string)
    member_name        = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Private Endpoint."
  type        = map(string)
  default     = {}
}
