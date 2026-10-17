variable "name" {
  description = "(Required) Specifies the name of the EventHub Namespace. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventHub Namespace exists."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Required) Defines which tier to use. Valid options are Basic, Standard, and Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of: 'Basic', 'Standard', 'Premium'."
  }
}

variable "capacity" {
  description = "(Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace (1-20) or Processing Units for Premium SKU (1, 2, 4, 8, 16)."
  type        = number
  default     = 1
}

variable "auto_inflate_enabled" {
  description = "(Optional) Is Auto Inflate enabled for the EventHub Namespace, and is its capacity allowed to expand automatically?"
  type        = bool
  default     = false
}

variable "maximum_throughput_units" {
  description = "(Optional) Specifies the maximum number of throughput units when Auto Inflate is enabled. Valid values range from 1 - 20."
  type        = number
  default     = null
}

variable "zone_redundant" {
  description = "(Optional) Specifies if the EventHub Namespace should be Zone Redundant (Standard or Premium SKU only)."
  type        = bool
  default     = false
}

variable "local_authentication_enabled" {
  description = "(Optional) Is SAS / local authentication enabled for the EventHub Namespace? Defaults to true."
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum supported TLS version for this EventHub Namespace. Valid values are 1.0, 1.1 and 1.2. Defaults to '1.2'."
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "(Optional) Is public network access enabled for the EventHub Namespace? Defaults to true."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "(Optional) Type of managed identity. Possible values are 'SystemAssigned', 'UserAssigned', or null."
  type        = string
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "network_rulesets" {
  description = "(Optional) Network ruleset configuration for the EventHub Namespace."
  type = object({
    default_action                 = optional(string, "Allow")
    public_network_access_enabled  = optional(bool, true)
    trusted_service_access_enabled = optional(bool, true)
    ip_rules                       = optional(list(string), [])
    virtual_network_subnet_ids     = optional(list(string), [])
  })
  default = null
}

variable "eventhubs" {
  description = "(Optional) Map of Event Hubs to create within this namespace."
  type = map(object({
    partition_count   = number
    message_retention = number
    status            = optional(string, "Active")
    capture_description = optional(object({
      enabled             = bool
      encoding            = string
      interval_in_seconds = optional(number, 300)
      size_limit_in_bytes = optional(number, 314572800)
      skip_empty_archives = optional(bool, true)
      destination = object({
        name                = string
        archive_name_format = string
        blob_container_name = string
        storage_account_id  = string
      })
    }), null)
  }))
  default = {}
}

variable "consumer_groups" {
  description = "(Optional) Map of consumer groups to create across Event Hubs. Key format: 'hub_name/consumer_group_name' or unique key."
  type = map(object({
    eventhub_name = string
    user_metadata = optional(string, null)
  }))
  default = {}
}

variable "authorization_rules" {
  description = "(Optional) Map of authorization rules to create for the EventHub Namespace."
  type = map(object({
    listen = optional(bool, true)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
