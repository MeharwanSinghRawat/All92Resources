output "id" {
  description = "The ID of the Management Group."
  value       = azurerm_management_group.mg.id
}

output "name" {
  description = "The Name of the Management Group."
  value       = azurerm_management_group.mg.name
}

output "display_name" {
  description = "The Display Name of the Management Group."
  value       = azurerm_management_group.mg.display_name
}
