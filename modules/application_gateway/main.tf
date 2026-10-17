resource "azurerm_application_gateway" "agw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = length(var.zones) > 0 ? var.zones : null

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.autoscale_configuration == null ? var.sku.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = try(autoscale_configuration.value.max_capacity, null)
    }
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = coalesce(frontend_port.value.name, frontend_port.key)
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = coalesce(backend_address_pool.value.name, backend_address_pool.key)
      fqdns        = length(backend_address_pool.value.fqdns) > 0 ? backend_address_pool.value.fqdns : null
      ip_addresses = length(backend_address_pool.value.ip_addresses) > 0 ? backend_address_pool.value.ip_addresses : null
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = coalesce(backend_http_settings.value.name, backend_http_settings.key)
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = coalesce(http_listener.value.name, http_listener.key)
      frontend_ip_configuration_name = coalesce(http_listener.value.frontend_ip_configuration_name, var.frontend_ip_configuration_name)
      frontend_port_name = coalesce(
        http_listener.value.frontend_port_name,
        try(var.frontend_ports[http_listener.key].name, null),
        http_listener.key
      )
      protocol             = http_listener.value.protocol
      ssl_certificate_name = http_listener.value.ssl_certificate_name
      host_name            = http_listener.value.host_name
      host_names           = length(http_listener.value.host_names) > 0 ? http_listener.value.host_names : null
      require_sni          = http_listener.value.require_sni
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name      = coalesce(request_routing_rule.value.name, request_routing_rule.key)
      rule_type = request_routing_rule.value.rule_type
      http_listener_name = coalesce(
        request_routing_rule.value.http_listener_name,
        try(var.http_listeners[request_routing_rule.value.http_listener_key].name, null),
        request_routing_rule.value.http_listener_key
      )
      backend_address_pool_name = coalesce(
        request_routing_rule.value.backend_address_pool_name,
        try(var.backend_address_pools[request_routing_rule.value.backend_address_pool_key].name, null),
        request_routing_rule.value.backend_address_pool_key
      )
      backend_http_settings_name = coalesce(
        request_routing_rule.value.backend_http_settings_name,
        try(var.backend_http_settings[request_routing_rule.value.backend_http_settings_key].name, null),
        request_routing_rule.value.backend_http_settings_key
      )
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      priority                    = request_routing_rule.value.priority
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name                                      = coalesce(probe.value.name, probe.key)
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings

      dynamic "match" {
        for_each = probe.value.match != null ? [probe.value.match] : []
        content {
          body        = match.value.body
          status_code = match.value.status_code
        }
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = coalesce(ssl_certificate.value.name, ssl_certificate.key)
      data                = ssl_certificate.value.data
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "waf_configuration" {
    for_each = var.sku.name == "WAF_v2" && var.waf_configuration != null ? [var.waf_configuration] : []
    content {
      enabled          = waf_configuration.value.enabled
      firewall_mode    = waf_configuration.value.firewall_mode
      rule_set_type    = waf_configuration.value.rule_set_type
      rule_set_version = waf_configuration.value.rule_set_version
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  tags = var.tags
}
