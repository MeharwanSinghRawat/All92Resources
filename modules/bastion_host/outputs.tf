output "id" {
  description = "The ID of the Bastion Host."
  value       = azurerm_bastion_host.bastion.id
}

output "name" {
  description = "The Name of the Bastion Host."
  value       = azurerm_bastion_host.bastion.name
}

output "dns_name" {
  description = "The FQDN for the Bastion Host."
  value       = azurerm_bastion_host.bastion.dns_name
}

output "public_ip_id" {
  description = "The ID of the Public IP assigned to the Bastion Host."
  value       = var.public_ip_id
}
