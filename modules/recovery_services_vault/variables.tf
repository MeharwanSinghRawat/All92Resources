variable "name" {
  description = "(Required) Specifies the name of the Recovery Services Vault. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Optional) Sets the vault's SKU. Possible values include: 'Standard', 'RS0'. Defaults to 'Standard'."
  type        = string
  default     = "Standard"
}

variable "storage_mode_type" {
  description = "(Optional) The storage type of the Recovery Services Vault. Possible values are 'GeoRedundant', 'LocallyRedundant', 'ZoneRedundant'. Defaults to 'LocallyRedundant'."
  type        = string
  default     = "LocallyRedundant"
}

variable "cross_region_restore_enabled" {
  description = "(Optional) Is cross region restore enabled for this Vault? Only valid when storage_mode_type is 'GeoRedundant'. Defaults to false."
  type        = bool
  default     = false
}

variable "soft_delete_enabled" {
  description = "(Optional) Is soft delete enabled for this Vault? Defaults to true."
  type        = bool
  default     = true
}

variable "vm_backup_policies" {
  description = "(Optional) Map of Virtual Machine backup policies to configure within this vault."
  type = map(object({
    name                  = optional(string)
    timezone              = optional(string, "UTC")
    frequency             = optional(string, "Daily")
    time                  = optional(string, "23:00")
    retention_daily_count = optional(number, 30)
    retention_weekly = optional(object({
      count    = number
      weekdays = list(string)
    }), null)
    retention_monthly = optional(object({
      count    = number
      weekdays = list(string)
      weeks    = list(string)
    }), null)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
