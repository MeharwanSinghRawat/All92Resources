variable "create_environment" {
  description = "(Optional) Whether to create a Container App Environment. Set to false if using an existing environment_id."
  type        = bool
  default     = true
}

variable "environment_name" {
  description = "(Optional) The name of the Container App Managed Environment. Required if create_environment is true."
  type        = string
  default     = null
}

variable "environment_id" {
  description = "(Optional) The ID of an existing Container App Managed Environment. Required if create_environment is false."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the resources should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region in which resources should exist."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The ID of the Log Analytics Workspace to link to the Container App Environment."
  type        = string
  default     = null
}

variable "infrastructure_subnet_id" {
  description = "(Optional) The ID of the Subnet used for the Container App Environment VNet integration."
  type        = string
  default     = null
}

variable "internal_load_balancer_enabled" {
  description = "(Optional) Should the Container App Environment have an internal load balancer only? Defaults to false."
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "(Optional) Should the Container App Environment have zone redundancy enabled? Defaults to false."
  type        = bool
  default     = false
}

variable "container_apps" {
  description = "(Optional) Map of Container Apps to create in this environment."
  type = map(object({
    revision_mode = optional(string, "Single")
    identity_type = optional(string, "SystemAssigned")
    identity_ids  = optional(list(string), [])

    secrets = optional(list(object({
      name  = string
      value = string
    })), [])

    registries = optional(list(object({
      server               = string
      username             = optional(string, null)
      password_secret_name = optional(string, null)
      identity             = optional(string, null)
    })), [])

    ingress = optional(object({
      external_enabled           = optional(bool, true)
      target_port                = number
      transport                  = optional(string, "auto")
      allow_insecure_connections = optional(bool, false)
      traffic_weight = optional(list(object({
        label           = optional(string, null)
        latest_revision = optional(bool, true)
        revision_suffix = optional(string, null)
        percentage      = number
      })), [{ percentage = 100, latest_revision = true }])
    }), null)

    template = object({
      min_replicas = optional(number, 0)
      max_replicas = optional(number, 10)
      containers = list(object({
        name   = string
        image  = string
        cpu    = number
        memory = string
        env = optional(list(object({
          name        = string
          value       = optional(string, null)
          secret_name = optional(string, null)
        })), [])
      }))
    })

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the environment."
  type        = map(string)
  default     = {}
}
