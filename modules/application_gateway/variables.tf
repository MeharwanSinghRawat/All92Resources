variable "name" {
  description = "(Required) The name of the Application Gateway."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 80
    error_message = "Application Gateway name must be between 1 and 80 characters."
  }
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Application Gateway should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Application Gateway will be created."
  type        = string
}

variable "sku" {
  description = "(Optional) SKU configuration for the Application Gateway."
  type = object({
    name     = optional(string, "Standard_v2")
    tier     = optional(string, "Standard_v2")
    capacity = optional(number, null)
  })
  default = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = null
  }

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku.name)
    error_message = "sku.name must be either 'Standard_v2' or 'WAF_v2'."
  }
}

variable "autoscale_configuration" {
  description = "(Optional) Autoscale configuration for the Application Gateway v2 SKU."
  type = object({
    min_capacity = number
    max_capacity = optional(number, 3)
  })
  default = {
    min_capacity = 1
    max_capacity = 2
  }
}

variable "zones" {
  description = "(Optional) A list of Availability Zones across which the Application Gateway will be deployed."
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "(Required) The ID of the dedicated Subnet where the Application Gateway should reside."
  type        = string
}

variable "public_ip_id" {
  description = "(Required) The ID of the Public IP Address to attach to the Application Gateway frontend."
  type        = string
}

variable "gateway_ip_configuration_name" {
  description = "(Optional) The name of the Gateway IP Configuration."
  type        = string
  default     = "appGatewayIpConfig"
}

variable "frontend_ip_configuration_name" {
  description = "(Optional) The default frontend IP configuration name."
  type        = string
  default     = "appGwPublicFrontendIp"
}

variable "frontend_ports" {
  description = "(Optional) Map of frontend ports to configure."
  type = map(object({
    port = number
    name = optional(string)
  }))
  default = {
    http = {
      port = 80
      name = "port_80"
    }
  }
}

variable "backend_address_pools" {
  description = "(Optional) Map of backend address pools."
  type = map(object({
    name         = optional(string)
    fqdns        = optional(list(string), [])
    ip_addresses = optional(list(string), [])
  }))
  default = {
    default = {
      name         = "default-backend-pool"
      fqdns        = []
      ip_addresses = []
    }
  }
}

variable "backend_http_settings" {
  description = "(Optional) Map of backend HTTP settings."
  type = map(object({
    name                                = optional(string)
    cookie_based_affinity               = optional(string, "Disabled")
    affinity_cookie_name                = optional(string, null)
    port                                = optional(number, 80)
    protocol                            = optional(string, "Http")
    request_timeout                     = optional(number, 30)
    probe_name                          = optional(string, null)
    path                                = optional(string, null)
    host_name                           = optional(string, null)
    pick_host_name_from_backend_address = optional(bool, false)
  }))
  default = {
    default = {
      name                                = "default-http-settings"
      cookie_based_affinity               = "Disabled"
      port                                = 80
      protocol                            = "Http"
      request_timeout                     = 30
      pick_host_name_from_backend_address = false
    }
  }
}

variable "http_listeners" {
  description = "(Optional) Map of HTTP listeners."
  type = map(object({
    name                           = optional(string)
    frontend_ip_configuration_name = optional(string, null)
    frontend_port_name             = optional(string, null)
    protocol                       = optional(string, "Http")
    ssl_certificate_name           = optional(string, null)
    host_name                      = optional(string, null)
    host_names                     = optional(list(string), [])
    require_sni                    = optional(bool, false)
  }))
  default = {
    http = {
      name       = "http-listener"
      protocol   = "Http"
      host_name  = null
      host_names = []
    }
  }
}

variable "request_routing_rules" {
  description = "(Optional) Map of request routing rules."
  type = map(object({
    name                        = optional(string)
    rule_type                   = optional(string, "Basic")
    http_listener_key           = optional(string, "http")
    http_listener_name          = optional(string, null)
    backend_address_pool_key    = optional(string, "default")
    backend_address_pool_name   = optional(string, null)
    backend_http_settings_key   = optional(string, "default")
    backend_http_settings_name  = optional(string, null)
    url_path_map_name           = optional(string, null)
    redirect_configuration_name = optional(string, null)
    priority                    = number
  }))
  default = {
    default = {
      name                      = "default-routing-rule"
      rule_type                 = "Basic"
      http_listener_key         = "http"
      backend_address_pool_key  = "default"
      backend_http_settings_key = "default"
      priority                  = 100
    }
  }
}

variable "probes" {
  description = "(Optional) Map of health probes."
  type = map(object({
    name                                      = optional(string)
    protocol                                  = optional(string, "Http")
    path                                      = optional(string, "/")
    host                                      = optional(string, null)
    interval                                  = optional(number, 30)
    timeout                                   = optional(number, 30)
    unhealthy_threshold                       = optional(number, 3)
    pick_host_name_from_backend_http_settings = optional(bool, false)
    match = optional(object({
      body        = optional(string, null)
      status_code = list(string)
    }), null)
  }))
  default = {}
}

variable "ssl_certificates" {
  description = "(Optional) Map of SSL certificates."
  type = map(object({
    name                = optional(string)
    data                = optional(string, null)
    password            = optional(string, null)
    key_vault_secret_id = optional(string, null)
  }))
  default = {}
}

variable "waf_configuration" {
  description = "(Optional) Web Application Firewall configuration when using WAF_v2 SKU."
  type = object({
    enabled          = bool
    firewall_mode    = optional(string, "Prevention")
    rule_set_type    = optional(string, "OWASP")
    rule_set_version = optional(string, "3.2")
  })
  default = null
}

variable "identity_type" {
  description = "(Optional) Managed Identity type. Possible values: 'UserAssigned' or null."
  type        = string
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Managed Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Application Gateway."
  type        = map(string)
  default     = {}
}
