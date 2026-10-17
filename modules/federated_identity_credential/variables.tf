variable "name" {
  description = "(Required) Specifies the name of the Federated Identity Credential. Changing this forces a new resource to be created."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 120 && can(regex("^[a-zA-Z0-9-_.()]+$", var.name))
    error_message = "Name must be 1-120 characters and contain only alphanumeric, hyphens, underscores, periods, and parentheses."
  }
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group within which the User Assigned Identity exists."
  type        = string
}

variable "parent_id" {
  description = "(Required) Specifies the ID of the User Assigned Identity to associate this Federated Credential with."
  type        = string
}

variable "audience" {
  description = "(Optional) Specifies the audience for this credential. Defaults to ['api://AzureADTokenExchange']."
  type        = list(string)
  default     = ["api://AzureADTokenExchange"]
}

variable "issuer" {
  description = "(Required) Specifies the URL of the external identity provider (e.g. AKS OIDC Issuer URL, or 'https://token.actions.githubusercontent.com')."
  type        = string
}

variable "subject" {
  description = "(Required) Specifies the identifier of the external workload (e.g. 'system:serviceaccount:<namespace>:<serviceaccount>' for Kubernetes or 'repo:<org>/<repo>:ref:refs/heads/main' for GitHub Actions)."
  type        = string
}
