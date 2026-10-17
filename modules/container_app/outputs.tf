output "environment_id" {
  description = "The ID of the Container App Environment."
  value       = local.environment_id
}

output "environment_default_domain" {
  description = "The default domain of the Container App Environment."
  value       = var.create_environment ? azurerm_container_app_environment.env[0].default_domain : null
}

output "environment_static_ip_address" {
  description = "The static IP of the Container App Environment."
  value       = var.create_environment ? azurerm_container_app_environment.env[0].static_ip_address : null
}

output "container_apps" {
  description = "Map of created Container Apps with IDs, FQDNs, and identities."
  value = {
    for k, v in azurerm_container_app.apps : k => {
      id                   = v.id
      fqdn                 = try(v.ingress[0].fqdn, null)
      identity             = try(v.identity[0], null)
      latest_revision_name = v.latest_revision_name
    }
  }
}
