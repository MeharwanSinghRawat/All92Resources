resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoints" {
  for_each = var.endpoints

  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  tags                     = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_groups" {
  for_each = var.origin_groups

  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  session_affinity_enabled = each.value.session_affinity_enabled

  load_balancing {
    sample_size                        = try(each.value.load_balancing.sample_size, 4)
    successful_samples_required        = try(each.value.load_balancing.successful_samples_required, 3)
    additional_latency_in_milliseconds = try(each.value.load_balancing.additional_latency_in_milliseconds, 50)
  }

  health_probe {
    path                = try(each.value.health_probe.path, "/")
    protocol            = try(each.value.health_probe.protocol, "Https")
    interval_in_seconds = try(each.value.health_probe.interval_in_seconds, 100)
    request_type        = try(each.value.health_probe.request_type, "HEAD")
  }
}

resource "azurerm_cdn_frontdoor_origin" "origins" {
  for_each = var.origins

  name                           = each.key
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin_groups[each.value.origin_group_name].id
  host_name                      = each.value.host_name
  http_port                      = try(each.value.http_port, 80)
  https_port                     = try(each.value.https_port, 443)
  origin_host_header             = coalesce(each.value.origin_host_header, each.value.host_name)
  priority                       = try(each.value.priority, 1)
  weight                         = try(each.value.weight, 1000)
  certificate_name_check_enabled = try(each.value.certificate_name_check_enabled, true)
  enabled                        = try(each.value.enabled, true)

  dynamic "private_link" {
    for_each = each.value.private_link != null ? [each.value.private_link] : []
    content {
      request_message        = private_link.value.request_message
      target_type            = private_link.value.target_type
      location               = private_link.value.location
      private_link_target_id = private_link.value.private_link_target_id
    }
  }
}

resource "azurerm_cdn_frontdoor_route" "routes" {
  for_each = var.routes

  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoints[each.value.endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_groups[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids = [
    for origin_k, origin_v in var.origins :
    azurerm_cdn_frontdoor_origin.origins[origin_k].id
    if origin_v.origin_group_name == each.value.origin_group_name
  ]

  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
  forwarding_protocol    = each.value.forwarding_protocol
  https_redirect_enabled = each.value.https_redirect_enabled
  link_to_default_domain = each.value.link_to_default_domain

  dynamic "cache" {
    for_each = each.value.cache != null ? [each.value.cache] : []
    content {
      query_string_caching_behavior = cache.value.query_string_caching_behavior
      query_strings                 = cache.value.query_strings
      compression_enabled           = cache.value.compression_enabled
      content_types_to_compress     = cache.value.content_types_to_compress
    }
  }
}
