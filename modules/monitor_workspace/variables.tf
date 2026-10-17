variable "name" {
  description = "Specifies the name of the Azure Monitor Workspace. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Azure Monitor Workspace should exist."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Azure Monitor Workspace should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the Azure Monitor Workspace. Defaults to true."
  type        = bool
  default     = true
}

variable "prometheus_rule_groups" {
  description = "Map of Prometheus alert and recording rule groups to configure for this Azure Monitor workspace."
  type = map(object({
    name                = string
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    description         = optional(string, null)
    rule_group_enabled  = optional(bool, true)
    interval            = optional(string, "PT1M")
    cluster_name        = optional(string, null)
    scopes              = optional(list(string), [])
    rules = list(object({
      enabled     = optional(bool, true)
      expression  = string
      record      = optional(string, null)
      alert       = optional(string, null)
      severity    = optional(number, null)
      for         = optional(string, null)
      labels      = optional(map(string), {})
      annotations = optional(map(string), {})
      actions = optional(list(object({
        action_group_id   = string
        action_properties = optional(map(string), {})
      })), [])
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the Azure Monitor Workspace and associated resources."
  type        = map(string)
  default     = {}
}
