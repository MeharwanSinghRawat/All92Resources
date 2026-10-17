variable "name" {
  description = "(Required) Specifies the name of the Front Door Profile. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Front Door Profile."
  type        = string
}

variable "sku_name" {
  description = "(Required) Specifies the SKU for this Front Door Profile. Possible values are 'Standard_AzureFrontDoor' and 'Premium_AzureFrontDoor'."
  type        = string
  default     = "Standard_AzureFrontDoor"

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.sku_name)
    error_message = "sku_name must be either 'Standard_AzureFrontDoor' or 'Premium_AzureFrontDoor'."
  }
}

variable "response_timeout_seconds" {
  description = "(Optional) Specifies the maximum response timeout in seconds. Possible values are between 16 and 240 seconds. Defaults to 120."
  type        = number
  default     = 120
}

variable "endpoints" {
  description = "(Optional) Map of Front Door endpoints to create."
  type = map(object({
    enabled = optional(bool, true)
    tags    = optional(map(string), {})
  }))
  default = {}
}

variable "origin_groups" {
  description = "(Optional) Map of Origin Groups to create."
  type = map(object({
    session_affinity_enabled = optional(bool, false)
    load_balancing = optional(object({
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
      additional_latency_in_milliseconds = optional(number, 50)
    }), {})
    health_probe = optional(object({
      path                = optional(string, "/")
      protocol            = optional(string, "Https")
      interval_in_seconds = optional(number, 100)
      request_type        = optional(string, "HEAD")
    }), {})
  }))
  default = {}
}

variable "origins" {
  description = "(Optional) Map of Origins to create. Key format: 'origin_group_name/origin_name' or unique identifier."
  type = map(object({
    origin_group_name              = string
    host_name                      = string
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
    origin_host_header             = optional(string, null)
    priority                       = optional(number, 1)
    weight                         = optional(number, 1000)
    certificate_name_check_enabled = optional(bool, true)
    enabled                        = optional(bool, true)
    private_link = optional(object({
      request_message        = optional(string, "Access request via Azure Front Door")
      target_type            = optional(string, null)
      location               = string
      private_link_target_id = string
    }), null)
  }))
  default = {}
}

variable "routes" {
  description = "(Optional) Map of Front Door routes to create."
  type = map(object({
    endpoint_name          = string
    origin_group_name      = string
    patterns_to_match      = optional(list(string), ["/*"])
    supported_protocols    = optional(list(string), ["Http", "Https"])
    forwarding_protocol    = optional(string, "HttpsOnly")
    https_redirect_enabled = optional(bool, true)
    link_to_default_domain = optional(bool, true)
    cache = optional(object({
      query_string_caching_behavior = optional(string, "IgnoreQueryString")
      query_strings                 = optional(list(string), [])
      compression_enabled           = optional(bool, true)
      content_types_to_compress     = optional(list(string), ["text/html", "application/javascript", "text/css", "application/json"])
    }), null)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
