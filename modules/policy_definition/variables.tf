variable "name" {
  description = "(Required) The name of the policy definition. Changing this forces a new resource to be created."
  type        = string
}

variable "policy_type" {
  description = "(Required) The policy type. Possible values are BuiltIn, Custom, NotSpecified. Defaults to Custom."
  type        = string
  default     = "Custom"
}

variable "mode" {
  description = "(Required) The policy mode that allows you to scan resource properties. Possible values are 'All', 'Indexed', 'NotSpecified'. Defaults to 'Indexed'."
  type        = string
  default     = "Indexed"
}

variable "display_name" {
  description = "(Required) The display name of the policy definition."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the policy definition."
  type        = string
  default     = null
}

variable "management_group_id" {
  description = "(Optional) The id of Management Group where this policy should be defined. If not specified, the policy will be defined at Subscription level."
  type        = string
  default     = null
}

variable "policy_rule" {
  description = "(Required) The policy rule for the policy definition in JSON string format."
  type        = string
}

variable "metadata" {
  description = "(Optional) The metadata for the policy definition in JSON string format."
  type        = string
  default     = null
}

variable "parameters" {
  description = "(Optional) Parameters for the policy definition in JSON string format."
  type        = string
  default     = null
}
