variable "name" {
  description = "(Required) The name of the Redis instance. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Redis instance should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region in which the Redis instance should exist."
  type        = string
}

variable "capacity" {
  description = "(Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) are 1, 2, 3, 4, 5."
  type        = number
  default     = 1
}

variable "family" {
  description = "(Required) The SKU family to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  type        = string
  default     = "C"

  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "family must be either 'C' or 'P'."
  }
}

variable "sku_name" {
  description = "(Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "sku_name must be one of: 'Basic', 'Standard', 'Premium'."
  }
}

variable "non_ssl_port_enabled" {
  description = "(Optional) Enable the non-SSL port (6379) -- Not recommended for production. Defaults to false."
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum TLS version. Possible values are 1.0, 1.1 and 1.2. Defaults to '1.2'."
  type        = string
  default     = "1.2"
}

variable "private_static_ip_address" {
  description = "(Optional) The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network. Valid only for Premium SKU."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "(Optional) The Subnet ID where the Redis Cache should be deployed. Valid only for Premium SKU."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Redis Cache. Defaults to true."
  type        = bool
  default     = true
}

variable "redis_version" {
  description = "(Optional) Redis version. Defaults to null (uses latest provider default, e.g. 6)."
  type        = string
  default     = null
}

variable "zones" {
  description = "(Optional) A list of Availability Zones across which this Redis Cache should be deployed. Supported only for Premium SKU."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "(Optional) The type of Managed Identity. Possible values are 'SystemAssigned', 'UserAssigned', or null."
  type        = string
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "redis_configuration" {
  description = "(Optional) Advanced Redis configuration options."
  type = object({
    authentication_enabled          = optional(bool, true)
    maxmemory_reserved              = optional(number, null)
    maxmemory_delta                 = optional(number, null)
    maxmemory_policy                = optional(string, "volatile-lru")
    maxfragmentationmemory_reserved = optional(number, null)
    rdb_backup_enabled              = optional(bool, false)
    rdb_backup_frequency            = optional(number, null)
    rdb_backup_max_snapshot_count   = optional(number, null)
    rdb_storage_connection_string   = optional(string, null)
  })
  default = {}
}

variable "patch_schedules" {
  description = "(Optional) List of patch schedule maintenance windows."
  type = list(object({
    day_of_week        = string
    start_hour_utc     = number
    maintenance_window = optional(string, "PT5H")
  }))
  default = []
}

variable "firewall_rules" {
  description = "(Optional) Map of IP firewall rules to apply to the Redis Cache."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
