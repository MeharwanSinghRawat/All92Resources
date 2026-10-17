output "id" {
  description = "The ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.vault.id
}

output "name" {
  description = "The Name of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.vault.name
}

output "vm_backup_policy_ids" {
  description = "Map of created VM backup policy IDs."
  value = {
    for k, v in azurerm_backup_policy_vm.policy : k => v.id
  }
}
