variable "name" {
  description = "(Required) The name of the Azure Storage Account. Must be globally unique, 3-24 characters, and contain only lowercase letters and numbers."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "Storage Account name must be between 3 and 24 characters and contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Storage Account will reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Storage Account will be created."
  type        = string
}

variable "account_tier" {
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are 'Standard' and 'Premium'."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account_tier must be either 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "(Optional) Defines the type of replication to use for this storage account. Valid options are 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "The account_replication_type must be one of: 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  }
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Defaults to 'StorageV2'."
  type        = string
  default     = "StorageV2"
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for storage requests. Defaults to 'TLS1_2'."
  type        = string
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to false."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key. Defaults to true."
  type        = bool
  default     = true
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled (Azure Data Lake Storage Gen2). Defaults to false."
  type        = bool
  default     = false
}

variable "blob_versioning_enabled" {
  description = "(Optional) Is blob versioning enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "blob_delete_retention_days" {
  description = "(Optional) The number of days that deleted blobs should be retained. Defaults to 7."
  type        = number
  default     = 7
}

variable "container_delete_retention_days" {
  description = "(Optional) The number of days that deleted containers should be retained. Defaults to 7."
  type        = number
  default     = 7
}

variable "network_rules" {
  description = "(Optional) Network rules restriction configuration."
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
    bypass                     = optional(list(string), ["AzureServices"])
  })
  default = null
}

variable "containers" {
  description = "(Optional) Map of blob containers to create inside this storage account."
  type = map(object({
    name                  = optional(string)
    container_access_type = optional(string, "private")
    metadata              = optional(map(string), {})
  }))
  default = {}
}

variable "file_shares" {
  description = "(Optional) Map of file shares to create inside this storage account."
  type = map(object({
    name  = optional(string)
    quota = optional(number, 50)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Storage Account."
  type        = map(string)
  default     = {}
}
