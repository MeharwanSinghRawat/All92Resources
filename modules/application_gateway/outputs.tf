output "id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.agw.id
}

output "name" {
  description = "The Name of the Application Gateway."
  value       = azurerm_application_gateway.agw.name
}

output "public_ip_id" {
  description = "The ID of the Public IP assigned to the Application Gateway."
  value       = var.public_ip_id
}

output "backend_address_pool_ids" {
  description = "Map of backend address pool names to their IDs."
  value = {
    for pool in azurerm_application_gateway.agw.backend_address_pool :
    pool.name => pool.id
  }
}

output "http_listener_ids" {
  description = "Map of HTTP listener names to their IDs."
  value = {
    for listener in azurerm_application_gateway.agw.http_listener :
    listener.name => listener.id
  }
}

output "request_routing_rule_ids" {
  description = "Map of request routing rule names to their IDs."
  value = {
    for rule in azurerm_application_gateway.agw.request_routing_rule :
    rule.name => rule.id
  }
}

output "identity_principal_id" {
  description = "The Principal ID of the UserAssigned identity (if applicable)."
  value       = try(azurerm_application_gateway.agw.identity[0].identity_ids, null)
}
