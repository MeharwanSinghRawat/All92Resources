variable "principal_id" {
  description = "(Required) The ID of the Principal (User, Group, Service Principal, or Managed Identity) to assign the Marketplace role to."
  type        = string
}

variable "role_definition_name" {
  description = "(Optional) The name of a built-in Role Definition for the Marketplace (e.g. 'Marketplace Admin'). Conflicts with role_definition_id."
  type        = string
  default     = null
}

variable "role_definition_id" {
  description = "(Optional) The Scoped-ID of the Role Definition for the Marketplace. Conflicts with role_definition_name."
  type        = string
  default     = null
}

variable "name" {
  description = "(Optional) A unique UUID for this Marketplace Role Assignment. Generated automatically if null."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) Description of the Marketplace Role Assignment."
  type        = string
  default     = null
}

variable "delegated_managed_identity_resource_id" {
  description = "(Optional) The delegated managed identity resource ID."
  type        = string
  default     = null
}

variable "condition" {
  description = "(Optional) The condition that limits the resources that the role can be assigned to."
  type        = string
  default     = null
}

variable "condition_version" {
  description = "(Optional) The version of the condition (e.g. '2.0')."
  type        = string
  default     = null
}

variable "skip_service_principal_aad_check" {
  description = "(Optional) If the principal_id is a newly created Service Principal or Managed Identity, setting this to true prevents replication delay errors. Defaults to false."
  type        = bool
  default     = false
}
