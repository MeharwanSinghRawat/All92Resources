variable "scope" {
  description = "(Required) The scope at which the Role Assignment applies to (e.g. a subscription ID, resource group ID, or specific resource ID)."
  type        = string
}

variable "role_definition_name" {
  description = "(Optional) The name of a built-in or custom Role Definition (e.g. 'Reader', 'Contributor', 'AcrPull', 'Key Vault Administrator'). Conflicts with 'role_definition_id'."
  type        = string
  default     = null
}

variable "role_definition_id" {
  description = "(Optional) The Scoped-ID of the Role Definition. Conflicts with 'role_definition_name'."
  type        = string
  default     = null
}

variable "principal_id" {
  description = "(Required) The ID of the Principal (User, Group, Service Principal, or Managed Identity) to assign the role to."
  type        = string
}

variable "name" {
  description = "(Optional) A unique UUID for this Role Assignment. If not provided, Azure / Terraform generates one automatically."
  type        = string
  default     = null
}

variable "principal_type" {
  description = "(Optional) The type of the principal_id. Possible values are 'User', 'Group', 'ServicePrincipal', or 'Application'. Defaults to null."
  type        = string
  default     = null

  validation {
    condition     = var.principal_type == null || contains(["User", "Group", "ServicePrincipal", "Application"], coalesce(var.principal_type, "User"))
    error_message = "principal_type must be one of: 'User', 'Group', 'ServicePrincipal', 'Application'."
  }
}

variable "description" {
  description = "(Optional) The description for this Role Assignment."
  type        = string
  default     = null
}

variable "skip_service_principal_aad_check" {
  description = "(Optional) If the principal_id is a newly created Service Principal or Managed Identity, setting this to true prevents AAD replication replication delay errors. Defaults to false."
  type        = bool
  default     = false
}

variable "condition" {
  description = "(Optional) The condition that limits the resources that the role can be assigned to."
  type        = string
  default     = null
}

variable "condition_version" {
  description = "(Optional) The version of the condition (e.g. '2.0'). Required if 'condition' is specified."
  type        = string
  default     = null
}
