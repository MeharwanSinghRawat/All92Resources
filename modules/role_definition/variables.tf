variable "name" {
  description = "(Required) The name of the Custom Role Definition."
  type        = string
}

variable "scope" {
  description = "(Required) The scope at which the Role Definition exists (e.g. subscription ID or management group ID)."
  type        = string
}

variable "role_definition_id" {
  description = "(Optional) A unique UUID for this Role Definition. If not provided, one will be generated automatically."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) A description of the Custom Role Definition."
  type        = string
  default     = null
}

variable "permissions" {
  description = "(Optional) List of permission blocks for the Custom Role."
  type = list(object({
    actions          = optional(list(string), [])
    not_actions      = optional(list(string), [])
    data_actions     = optional(list(string), [])
    not_data_actions = optional(list(string), [])
  }))
  default = []
}

variable "assignable_scopes" {
  description = "(Optional) One or more assignable scopes where this role can be assigned. Defaults to [var.scope]."
  type        = list(string)
  default     = null
}
