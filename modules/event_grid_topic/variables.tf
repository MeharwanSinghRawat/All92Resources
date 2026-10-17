variable "name" {
  description = "(Required) Specifies the name of the EventGrid Topic. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventGrid Topic exists."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "input_schema" {
  description = "(Optional) Specifies the schema in which incoming events will be published to this domain. Allowed values are 'EventGridSchema', 'CustomEventSchema', or 'CloudEventSchemaV1_0'. Defaults to 'EventGridSchema'."
  type        = string
  default     = "EventGridSchema"

  validation {
    condition     = contains(["EventGridSchema", "CustomEventSchema", "CloudEventSchemaV1_0"], var.input_schema)
    error_message = "input_schema must be one of: 'EventGridSchema', 'CustomEventSchema', 'CloudEventSchemaV1_0'."
  }
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this server. Defaults to true."
  type        = bool
  default     = true
}

variable "local_auth_enabled" {
  description = "(Optional) Whether local authentication methods (SAS tokens) are enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "inbound_ip_rules" {
  description = "(Optional) List of IP masks to allow/deny access."
  type = list(object({
    ip_mask = string
    action  = optional(string, "Allow")
  }))
  default = []
}

variable "identity_type" {
  description = "(Optional) Type of Managed Identity ('SystemAssigned', 'UserAssigned', or null)."
  type        = string
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "subscriptions" {
  description = "(Optional) Map of Event Subscriptions to attach to this Event Grid Topic."
  type = map(object({
    event_delivery_schema = optional(string, "EventGridSchema")
    webhook_endpoint = optional(object({
      url                               = string
      max_events_per_batch              = optional(number, 1)
      preferred_batch_size_in_kilobytes = optional(number, 64)
      active_directory_tenant_id        = optional(string, null)
      active_directory_app_id_or_uri    = optional(string, null)
    }), null)
    azure_function_endpoint = optional(object({
      function_id                       = string
      max_events_per_batch              = optional(number, 1)
      preferred_batch_size_in_kilobytes = optional(number, 64)
    }), null)
    service_bus_queue_endpoint_id = optional(string, null)
    service_bus_topic_endpoint_id = optional(string, null)
    eventhub_endpoint_id          = optional(string, null)
    included_event_types          = optional(list(string), [])
    retry_policy = optional(object({
      max_delivery_attempts         = optional(number, 30)
      event_time_to_live_in_minutes = optional(number, 1440)
    }), null)
    subject_filter = optional(object({
      subject_begins_with = optional(string, null)
      subject_ends_with   = optional(string, null)
      case_sensitive      = optional(bool, false)
    }), null)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
