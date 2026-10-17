variable "name" {
  description = "(Required) Specifies the name of the ServiceBus Namespace resource. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the namespace."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Optional) Defines which tier to use. Options are basic, standard or premium. Defaults to 'Standard'."
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "(Optional) Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4, 8 or 16. Defaults to null."
  type        = number
  default     = null
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum supported TLS version for this ServiceBus Namespace. Valid values are: '1.0', '1.1' and '1.2'. Defaults to '1.2'."
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "(Optional) Is public network access enabled for the ServiceBus Namespace? Defaults to true."
  type        = bool
  default     = true
}

variable "queues" {
  description = "(Optional) Map of ServiceBus queues to configure."
  type = map(object({
    name                                 = optional(string)
    max_size_in_megabytes                = optional(number, 1024)
    dead_lettering_on_message_expiration = optional(bool, true)
    default_message_ttl                  = optional(string, "P14D")
    lock_duration                        = optional(string, "PT1M")
    max_delivery_count                   = optional(number, 10)
    requires_session                     = optional(bool, false)
    requires_duplicate_detection         = optional(bool, false)
  }))
  default = {}
}

variable "topics" {
  description = "(Optional) Map of ServiceBus topics to configure (Requires Standard or Premium SKU)."
  type = map(object({
    name                         = optional(string)
    max_size_in_megabytes        = optional(number, 1024)
    default_message_ttl          = optional(string, "P14D")
    requires_duplicate_detection = optional(bool, false)
    support_ordering             = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
