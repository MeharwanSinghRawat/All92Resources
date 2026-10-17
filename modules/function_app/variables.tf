variable "name" {
  description = "(Required) The name of the Function App. Must be globally unique, 1-60 characters, and contain only alphanumeric characters and hyphens."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 60 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name))
    error_message = "Function App name must be between 1 and 60 characters, and contain only alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Function App will reside."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Function App will be created."
  type        = string
}

variable "service_plan_id" {
  description = "(Optional) The ID of an existing App Service Plan. If null, a new Service Plan will be created using sku_name."
  type        = string
  default     = null
}

variable "service_plan_name" {
  description = "(Optional) The name of the Service Plan to create if service_plan_id is null. Defaults to '<name>-asp'."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "(Optional) The SKU Name of the Service Plan to create (e.g. 'Y1' for Consumption, 'EP1' for Elastic Premium, 'B1', 'S1', 'P1v3'). Defaults to 'Y1'."
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "(Required) The backend Storage Account name used by the Function App for runtime storage."
  type        = string
}

variable "storage_account_access_key" {
  description = "(Optional) The access key for the backend Storage Account. Required unless storage_uses_managed_identity is true."
  type        = string
  default     = null
  sensitive   = true
}

variable "storage_uses_managed_identity" {
  description = "(Optional) Whether the Function App uses Managed Identity to access the storage account instead of an access key. Defaults to false."
  type        = bool
  default     = false
}

variable "functions_extension_version" {
  description = "(Optional) The runtime version of Azure Functions. Defaults to '~4'."
  type        = string
  default     = "~4"
}

variable "https_only" {
  description = "(Optional) Can the Function App only be accessed via HTTPS? Defaults to true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is enabled for the Function App. Defaults to true."
  type        = bool
  default     = true
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The ID of a delegated Subnet (Microsoft.Web/serverFarms) to connect for outbound virtual network integration."
  type        = string
  default     = null
}

variable "vnet_route_all_enabled" {
  description = "(Optional) Should all outbound traffic be routed through the Virtual Network? Defaults to false."
  type        = bool
  default     = false
}

variable "application_insights_connection_string" {
  description = "(Optional) The Application Insights Connection String for monitoring."
  type        = string
  default     = null
  sensitive   = true
}

variable "application_insights_key" {
  description = "(Optional) The Instrumentation Key for Application Insights."
  type        = string
  default     = null
  sensitive   = true
}

variable "identity_type" {
  description = "(Optional) The type of Managed Identity. Options: 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'. Defaults to 'SystemAssigned'."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "(Optional) A list of User Assigned Identity IDs when identity_type includes 'UserAssigned'."
  type        = list(string)
  default     = []
}

variable "application_stack" {
  description = "(Optional) The application runtime stack configuration (e.g., python_version, node_version, dotnet_version, java_version)."
  type = object({
    dotnet_version              = optional(string)
    java_version                = optional(string)
    node_version                = optional(string)
    powershell_core_version     = optional(string)
    python_version              = optional(string, "3.11")
    use_custom_runtime          = optional(bool)
    use_dotnet_isolated_runtime = optional(bool)
  })
  default = {
    python_version = "3.11"
  }
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs for Function App application settings (environment variables)."
  type        = map(string)
  default     = {}
}

variable "functions" {
  description = "(Optional) Map of individual serverless functions ('azurerm_function_app_function') to create inside the Function App."
  type = map(object({
    name        = optional(string)
    config_json = string
    language    = optional(string, null)
    enabled     = optional(bool, true)
    test_data   = optional(string, null)
    files = optional(map(object({
      name    = optional(string)
      content = string
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
