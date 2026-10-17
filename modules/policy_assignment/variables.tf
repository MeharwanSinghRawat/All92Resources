variable "name" {
  description = "(Required) The name of the Policy Assignment. Changing this forces a new resource to be created."
  type        = string
}

variable "scope_type" {
  description = "(Optional) The scope type for the policy assignment: 'subscription' or 'resource_group'. Defaults to 'subscription'."
  type        = string
  default     = "subscription"

  validation {
    condition     = contains(["subscription", "resource_group"], var.scope_type)
    error_message = "scope_type must be either 'subscription' or 'resource_group'."
  }
}

variable "subscription_id" {
  description = "(Optional) The Subscription ID where the policy will be assigned. Required when scope_type is 'subscription'."
  type        = string
  default     = null
}

variable "resource_group_id" {
  description = "(Optional) The Resource Group ID where the policy will be assigned. Required when scope_type is 'resource_group'."
  type        = string
  default     = null
}

variable "policy_definition_id" {
  description = "(Required) The ID of the Policy Definition or Policy Set Definition to assign."
  type        = string
}

variable "display_name" {
  description = "(Optional) The display name for this Policy Assignment."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) A description of the Policy Assignment."
  type        = string
  default     = null
}

variable "enforce" {
  description = "(Optional) Can be set to true or false to control whether the policy is enforced or not. Defaults to true."
  type        = bool
  default     = true
}

variable "parameters" {
  description = "(Optional) Parameters for the policy assignment in JSON string format."
  type        = string
  default     = null
}

variable "location" {
  description = "(Optional) The Azure Region where the Policy Assignment should exist. Required when identity_type is specified."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "(Optional) The type of Managed Identity: 'SystemAssigned' or 'UserAssigned'."
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "(Optional) A list of User Assigned Managed Identity IDs to be assigned to this Policy Assignment."
  type        = list(string)
  default     = null
}

variable "non_compliance_messages" {
  description = "(Optional) A list of non-compliance messages to be displayed when a resource is non-compliant."
  type = list(object({
    content                        = string
    policy_definition_reference_id = optional(string, null)
  }))
  default = []
}
