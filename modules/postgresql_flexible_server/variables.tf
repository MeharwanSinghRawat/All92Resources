variable "name" {
  description = "(Required) The name of the PostgreSQL Flexible Server. Must be globally unique, 1-63 characters, and contain only lowercase letters, numbers, and hyphens."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 63 && can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name))
    error_message = "Server name must be 1-63 characters, start and end with an alphanumeric character, and contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the PostgreSQL Flexible Server will reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the PostgreSQL Flexible Server will be created."
  type        = string
}

variable "server_version" {
  description = "(Optional) The version of PostgreSQL to use. Valid values include '12', '13', '14', '15', '16'. Defaults to '16'."
  type        = string
  default     = "16"

  validation {
    condition     = contains(["12", "13", "14", "15", "16"], var.server_version)
    error_message = "The PostgreSQL version must be one of: '12', '13', '14', '15', '16'."
  }
}

variable "sku_name" {
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. Defaults to 'B_Standard_B1ms'."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server in MB. Defaults to 32768."
  type        = number
  default     = 32768
}

variable "storage_tier" {
  description = "(Optional) The name of storage tier for the PostgreSQL Flexible Server (e.g. 'P4', 'P6', 'P10', 'P15', 'P20', 'P30'). Defaults to null."
  type        = string
  default     = null
}

variable "auto_grow_enabled" {
  description = "(Optional) Is storage auto-grow enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "(Optional) The backup retention days for the PostgreSQL Flexible Server. Supported values are between 7 and 35. Defaults to 7."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "backup_retention_days must be between 7 and 35."
  }
}

variable "geo_redundant_backup_enabled" {
  description = "(Optional) Is Geo-Redundant backup enabled for this PostgreSQL Flexible Server? Defaults to false."
  type        = bool
  default     = false
}

variable "create_mode" {
  description = "(Optional) The creation mode. Valid options are 'Default', 'Update', 'PointInTimeRestore', 'Replica'. Defaults to 'Default'."
  type        = string
  default     = "Default"

  validation {
    condition     = contains(["Default", "Update", "PointInTimeRestore", "Replica"], var.create_mode)
    error_message = "create_mode must be one of: 'Default', 'Update', 'PointInTimeRestore', 'Replica'."
  }
}

variable "source_server_id" {
  description = "(Optional) The resource ID of the source PostgreSQL Flexible Server to be restored from or replicated. Required when create_mode is PointInTimeRestore or Replica."
  type        = string
  default     = null
}

variable "point_in_time_restore_time_in_utc" {
  description = "(Optional) The point in time to restore from UTC RFC3339 format. Required when create_mode is PointInTimeRestore."
  type        = string
  default     = null
}

variable "zone" {
  description = "(Optional) Specifies the Availability Zone in which this PostgreSQL Flexible Server should be located. (e.g. '1', '2', '3')."
  type        = string
  default     = null
}

variable "administrator_login" {
  description = "(Optional) The Administrator login for the PostgreSQL Flexible Server. Required when create_mode is Default. Defaults to 'psqladmin'."
  type        = string
  default     = "psqladmin"
}

variable "administrator_password" {
  description = "(Optional) The Password associated with the administrator_login. If not specified, a secure random password will be automatically generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_password_length" {
  description = "(Optional) The length of the randomly generated administrator password. Defaults to 24."
  type        = number
  default     = 24
}

variable "delegated_subnet_id" {
  description = "(Optional) The ID of the virtual network subnet delegated to 'Microsoft.DBforPostgreSQL/flexibleServers' to create the server in. When set, private access via VNet is used."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "(Optional) The ID of the private DNS zone to link to the PostgreSQL Flexible Server. Required when delegated_subnet_id is set."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this server. Defaults to false."
  type        = bool
  default     = false
}

variable "high_availability" {
  description = "(Optional) High availability configuration block."
  type = object({
    mode                      = string
    standby_availability_zone = optional(string, null)
  })
  default = null
}

variable "maintenance_window" {
  description = "(Optional) Maintenance window configuration block."
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  default = null
}

variable "authentication" {
  description = "(Optional) Authentication configuration block."
  type = object({
    active_directory_auth_enabled = optional(bool, false)
    password_auth_enabled         = optional(bool, true)
    tenant_id                     = optional(string, null)
  })
  default = null
}

variable "identity" {
  description = "(Optional) Managed identity block."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}

variable "customer_managed_key" {
  description = "(Optional) Customer Managed Key block for data encryption."
  type = object({
    key_vault_key_id                  = string
    primary_user_assigned_identity_id = string
  })
  default = null
}

variable "databases" {
  description = "(Optional) Map of databases to create on the PostgreSQL Flexible Server."
  type = map(object({
    name      = optional(string)
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
  }))
  default = {}
}

variable "firewall_rules" {
  description = "(Optional) Map of firewall rules to create for the server (when public network access is enabled)."
  type = map(object({
    name             = optional(string)
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "server_configurations" {
  description = "(Optional) Map of server configuration parameters (e.g., {'work_mem' = '8MB', 'azure.extensions' = 'citus'})."
  type        = map(string)
  default     = {}
}

variable "ad_admin" {
  description = "(Optional) Azure Active Directory administrator configuration."
  type = object({
    object_id      = string
    principal_name = string
    principal_type = string
    tenant_id      = string
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
