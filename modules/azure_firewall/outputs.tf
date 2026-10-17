output "id" {
  description = "The ID of the Azure Firewall."
  value       = azurerm_firewall.fw.id
}

output "name" {
  description = "The Name of the Azure Firewall."
  value       = azurerm_firewall.fw.name
}

output "private_ip_address" {
  description = "The private IP address of the Azure Firewall."
  value       = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "public_ip_id" {
  description = "The ID of the Public IP assigned to the Azure Firewall."
  value       = var.public_ip_id
}

output "public_ip_address" {
  description = "The Public IP address assigned to the Azure Firewall."
  value       = var.public_ip_address
}

output "firewall_policy_id" {
  description = "The ID of the Firewall Policy attached to this firewall."
  value       = var.create_firewall_policy && var.firewall_policy_id == null ? azurerm_firewall_policy.policy[0].id : var.firewall_policy_id
}
