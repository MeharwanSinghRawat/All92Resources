variable "key_vault_id" {
  description = "(Required) The ID of the Key Vault where the Secret should be created."
  type        = string
}

variable "secrets" {
  description = "(Required) Map of secrets to store in the Key Vault."
  type = map(object({
    name            = optional(string)
    value           = string
    content_type    = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(string), {})
  }))
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all secrets."
  type        = map(string)
  default     = {}
}
