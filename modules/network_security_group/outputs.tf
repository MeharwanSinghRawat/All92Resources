output "id" {
  description = "The ID of the Network Security Group."
  value       = azurerm_network_security_group.nsg.id
}

output "name" {
  description = "The Name of the Network Security Group."
  value       = azurerm_network_security_group.nsg.name
}

output "resource_group_name" {
  description = "The Resource Group Name of the Network Security Group."
  value       = azurerm_network_security_group.nsg.resource_group_name
}

output "location" {
  description = "The Location of the Network Security Group."
  value       = azurerm_network_security_group.nsg.location
}

output "security_rule_ids" {
  description = "Map of security rule keys to their corresponding Azure resource IDs."
  value       = { for k, v in azurerm_network_security_rule.rules : k => v.id }
}
