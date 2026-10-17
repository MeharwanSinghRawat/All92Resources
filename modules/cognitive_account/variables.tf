variable "name" {
  description = "(Required) Specifies the name of the Cognitive Service / AI Account. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Cognitive Service Account is created."
  type        = string
}

variable "location" {
  description = "(Required) Supported Azure location where the resource exists."
  type        = string
}

variable "kind" {
  description = "(Required) Specifies the type of Cognitive Service Account that should be created. (e.g. 'OpenAI', 'CognitiveServices', 'ComputerVision', 'TextAnalytics', 'SpeechServices')."
  type        = string
  default     = "OpenAI"
}

variable "sku_name" {
  description = "(Required) Specifies the SKU Name for this Cognitive Service Account. Possible values include 'S0', 'S', 'F0', etc. Defaults to 'S0'."
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "(Optional) The subdomain name used for token-based authentication and private endpoint bindings. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Cognitive Account. Defaults to true."
  type        = bool
  default     = true
}

variable "outbound_network_access_restricted" {
  description = "(Optional) Whether outbound network access is restricted for the Cognitive Account. Defaults to false."
  type        = bool
  default     = false
}

variable "local_auth_enabled" {
  description = "(Optional) Whether local authentication methods (API Keys) are enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "(Optional) Type of Managed Identity ('SystemAssigned', 'UserAssigned', or null)."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "network_acls" {
  description = "(Optional) Network ACL configuration for the Cognitive Service Account."
  type = object({
    default_action = optional(string, "Allow")
    ip_rules       = optional(list(string), [])
    virtual_network_rules = optional(list(object({
      subnet_id                            = string
      ignore_missing_vnet_service_endpoint = optional(bool, false)
    })), [])
  })
  default = null
}

variable "deployments" {
  description = "(Optional) Map of model deployments to create in this Cognitive / OpenAI account."
  type = map(object({
    model_format  = optional(string, "OpenAI")
    model_name    = string
    model_version = optional(string, null)
    sku_name      = optional(string, "Standard")
    scale_type    = optional(string, null)
    capacity      = optional(number, 10)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
