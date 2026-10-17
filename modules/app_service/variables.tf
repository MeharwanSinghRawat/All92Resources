variable "name" {
  description = "(Required) Specifies the name of the App Service (Web App). Must be globally unique across Azure."
  type        = string

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 60 && can(regex("^[a-zA-Z0-9-][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name))
    error_message = "App Service name must be between 2 and 60 characters and contain only alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the App Service and Plan reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the App Service will be deployed."
  type        = string
}

variable "os_type" {
  description = "(Optional) The operating system type for the App Service. Possible values are 'Linux' and 'Windows'. Defaults to 'Linux'."
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be either 'Linux' or 'Windows'."
  }
}

variable "service_plan_id" {
  description = "(Required) The ID of the App Service Plan to host this Web App."
  type        = string
}

variable "service_plan_name" {
  description = "(Optional) The name of the new App Service Plan to create if service_plan_id is null. Defaults to '<name>-asp'."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "(Optional) The SKU Name for the App Service Plan (e.g. F1, B1, B2, B3, S1, S2, S3, P1v2, P1v3). Defaults to 'B1'."
  type        = string
  default     = "B1"
}

variable "worker_count" {
  description = "(Optional) The number of Workers (instances) for this App Service Plan. Defaults to null."
  type        = number
  default     = null
}

variable "zone_balancing_enabled" {
  description = "(Optional) Should Zone Balancing be enabled for the App Service Plan? Requires Premium SKU. Defaults to false."
  type        = bool
  default     = false
}

variable "https_only" {
  description = "(Optional) Should HTTPS be enforced for all incoming traffic? Defaults to true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Should public network access be enabled for the App Service? Defaults to true."
  type        = bool
  default     = true
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The ID of the Subnet for regional virtual network integration. Defaults to null."
  type        = string
  default     = null
}

variable "vnet_route_all_enabled" {
  description = "(Optional) Should all outbound traffic be routed through the virtual network? Defaults to true."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "(Optional) Type of Managed Service Identity. Possible values are 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned', or null."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type contains 'UserAssigned'."
  type        = list(string)
  default     = []
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs representing application settings / environment variables."
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "(Optional) Map of connection strings to configure on the Web App."
  type = map(object({
    type  = string
    value = string
  }))
  default = {}
}

variable "application_stack" {
  description = "(Optional) Application stack runtime configuration."
  type = object({
    dotnet_version           = optional(string)
    java_version             = optional(string)
    node_version             = optional(string)
    php_version              = optional(string)
    python_version           = optional(string)
    ruby_version             = optional(string)
    docker_image_name        = optional(string)
    docker_registry_url      = optional(string)
    docker_registry_username = optional(string)
    docker_registry_password = optional(string)
    current_stack            = optional(string)
  })
  default = {}
}

variable "site_config" {
  description = "(Optional) Advanced site configuration."
  type = object({
    always_on                  = optional(bool, false)
    http2_enabled              = optional(bool, true)
    minimum_tls_version        = optional(string, "1.2")
    ftps_state                 = optional(string, "Disabled")
    health_check_path          = optional(string)
    health_check_eviction_time = optional(number)
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool, false)
    }))
  })
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
