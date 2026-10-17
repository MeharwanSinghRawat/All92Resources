output "id" {
  description = "The ID of the Front Door Profile."
  value       = azurerm_cdn_frontdoor_profile.profile.id
}

output "name" {
  description = "The name of the Front Door Profile."
  value       = azurerm_cdn_frontdoor_profile.profile.name
}

output "resource_guid" {
  description = "The UUID of the Front Door Profile."
  value       = azurerm_cdn_frontdoor_profile.profile.resource_guid
}

output "endpoints" {
  description = "Map of created endpoints with IDs and hostnames."
  value = {
    for k, v in azurerm_cdn_frontdoor_endpoint.endpoints : k => {
      id        = v.id
      host_name = v.host_name
    }
  }
}

output "origin_groups" {
  description = "Map of created origin group IDs."
  value = {
    for k, v in azurerm_cdn_frontdoor_origin_group.origin_groups : k => v.id
  }
}

output "origins" {
  description = "Map of created origin IDs."
  value = {
    for k, v in azurerm_cdn_frontdoor_origin.origins : k => v.id
  }
}
