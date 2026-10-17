variable "name" {
  description = "(Required) The name of the Private DNS Zone (e.g. 'privatelink.postgres.database.azure.com', 'privatelink.blob.core.windows.net')."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 253
    error_message = "Private DNS Zone name must be between 1 and 253 characters."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Private DNS Zone will reside."
  type        = string
}

variable "virtual_network_links" {
  description = "(Optional) Map of Virtual Network Links to associate with this Private DNS Zone."
  type = map(object({
    name                 = optional(string)
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
