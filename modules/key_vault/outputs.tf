output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.vault.id
}

output "name" {
  description = "The Name of the Key Vault."
  value       = azurerm_key_vault.vault.name
}

output "vault_uri" {
  description = "The URI of the Key Vault for performing operations on keys and secrets."
  value       = azurerm_key_vault.vault.vault_uri
}

output "resource_group_name" {
  description = "The Resource Group Name where the Key Vault resides."
  value       = azurerm_key_vault.vault.resource_group_name
}

output "location" {
  description = "The Location of the Key Vault."
  value       = azurerm_key_vault.vault.location
}

output "secret_ids" {
  description = "Map of secret keys to their versionless IDs."
  value       = { for k, v in azurerm_key_vault_secret.secrets : k => v.versionless_id }
}

output "key_ids" {
  description = "Map of key keys to their versionless IDs."
  value       = { for k, v in azurerm_key_vault_key.keys : k => v.versionless_id }
}
