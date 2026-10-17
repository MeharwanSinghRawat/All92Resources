variable "name" {
  description = "(Required) The name of the Resource Group. Must be unique within the Azure subscription."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 90 && can(regex("^[a-zA-Z0-9._()\\-]+$", var.name))
    error_message = "The Resource Group name must be between 1 and 90 characters, and can only contain alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}

variable "location" {
  description = "(Required) The Azure region where the Resource Group should be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Resource Group."
  type        = map(string)
  default     = {}
}

variable "lock_level" {
  description = "(Optional) Specifies the lock level to apply to the Resource Group. Possible values are 'CanNotDelete' and 'ReadOnly'. Set to null for no lock."
  type        = string
  default     = null

  validation {
    condition     = var.lock_level == null || contains(["CanNotDelete", "ReadOnly"], coalesce(var.lock_level, "null"))
    error_message = "The lock_level value must be either 'CanNotDelete', 'ReadOnly', or null."
  }
}

variable "lock_notes" {
  description = "(Optional) Specifies notes regarding the lock."
  type        = string
  default     = "Managed by Terraform"
}

variable "role_assignments" {
  description = "(Optional) A map of RBAC role assignments to create on the Resource Group scope."
  type = map(object({
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
    principal_id         = string
    condition            = optional(string)
    condition_version    = optional(string)
    description          = optional(string)
  }))
  default = {}
}
