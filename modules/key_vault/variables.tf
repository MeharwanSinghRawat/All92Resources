variable "name" {
  description = "(Required) Specifies the name of the Key Vault. Key Vault names must be 3-24 characters, alphanumeric and hyphens, and unique across Azure."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "The Key Vault name must be between 3 and 24 characters and may only contain alphanumeric characters and dashes."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure region where the resource exists."
  type        = string
}

variable "sku_name" {
  description = "(Optional) The Name of the SKU used for this Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku_name must be either 'standard' or 'premium'."
  }
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Once activated, it cannot be disabled."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained once soft-deleted. Must be between 7 and 90."
  type        = number
  default     = 7

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90 days."
  }
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is enabled for this Key Vault. Defaults to true."
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "(Optional) Network rules restriction configuration."
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "access_policies" {
  description = "(Optional) Map of access policies for the Key Vault (applicable when enable_rbac_authorization is false or hybrid)."
  type = map(object({
    object_id               = string
    tenant_id               = optional(string)
    application_id          = optional(string)
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

variable "role_assignments" {
  description = "(Optional) Map of role assignments for Azure RBAC authorization."
  type = map(object({
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    principal_id         = string
    description          = optional(string)
  }))
  default = {}
}

variable "secrets" {
  description = "(Optional) Map of Key Vault secrets to create."
  type = map(object({
    name            = optional(string)
    value           = string
    content_type    = optional(string)
    not_before_date = optional(string)
    expiration_date = optional(string)
    tags            = optional(map(string), {})
  }))
  default = {}
}

variable "keys" {
  description = "(Optional) Map of Key Vault keys to create."
  type = map(object({
    name     = optional(string)
    key_type = optional(string, "RSA")
    key_size = optional(number, 2048)
    key_opts = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])
    tags     = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Key Vault."
  type        = map(string)
  default     = {}
}
