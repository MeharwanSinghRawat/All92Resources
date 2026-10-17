variable "name" {
  description = "(Required) The name of the Microsoft SQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Microsoft SQL Server."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "server_version" {
  description = "(Optional) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Defaults to 12.0."
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "(Optional) The administrator login name for the new server. Defaults to 'sqladmin'."
  type        = string
  default     = "sqladmin"
}

variable "administrator_login_password" {
  description = "(Optional) The password associated with the administrator_login user. If null, a secure random password will be generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "(Optional) The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases contained in this server. Defaults to '1.2'."
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this server. Defaults to false."
  type        = bool
  default     = false
}

variable "azuread_administrator" {
  description = "(Optional) Azure Active Directory administrator configuration."
  type = object({
    login_username              = string
    object_id                   = string
    tenant_id                   = optional(string)
    azuread_authentication_only = optional(bool, false)
  })
  default = null
}

variable "databases" {
  description = "(Optional) Map of SQL databases to create on this server."
  type = map(object({
    name               = optional(string)
    sku_name           = optional(string, "Basic")
    max_size_gb        = optional(number, 2)
    geo_backup_enabled = optional(bool, false)
    collation          = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "firewall_rules" {
  description = "(Optional) Map of firewall rules for this server."
  type = map(object({
    name             = optional(string)
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
