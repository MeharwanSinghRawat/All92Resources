variable "name" {
  description = "(Required) Specifies the name of this User Assigned Identity. Must be between 3 and 128 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 128 && can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "Identity name must be between 3 and 128 characters and can only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group within which this User Assigned Identity should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure location where the User Assigned Identity should exist."
  type        = string
}

variable "federated_identity_credentials" {
  description = "(Optional) Map of Federated Identity Credentials (for AKS Workload Identity or GitHub Actions OIDC)."
  type = map(object({
    name     = optional(string)
    audience = optional(list(string), ["api://AzureADTokenExchange"])
    issuer   = string
    subject  = string
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity."
  type        = map(string)
  default     = {}
}
