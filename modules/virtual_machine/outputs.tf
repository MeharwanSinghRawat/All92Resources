output "id" {
  description = "The ID of the Virtual Machine."
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.vm_linux[0].id : azurerm_windows_virtual_machine.vm_windows[0].id
}

output "name" {
  description = "The Name of the Virtual Machine."
  value       = var.name
}

output "network_interface_id" {
  description = "The ID of the Primary Network Interface."
  value       = azurerm_network_interface.nic.id
}

output "private_ip_address" {
  description = "The Primary Private IP Address of the Virtual Machine."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "public_ip_id" {
  description = "The ID of the Public IP Address attached to the Virtual Machine (if any)."
  value       = var.public_ip_id
}

output "identity_principal_id" {
  description = "The Principal ID of the SystemAssigned identity."
  value = (
    var.os_type == "Linux" ? try(azurerm_linux_virtual_machine.vm_linux[0].identity[0].principal_id, null) :
    try(azurerm_windows_virtual_machine.vm_windows[0].identity[0].principal_id, null)
  )
}

output "data_disk_ids" {
  description = "Map of data disk keys to their resource IDs."
  value       = { for k, v in azurerm_managed_disk.data_disk : k => v.id }
}
