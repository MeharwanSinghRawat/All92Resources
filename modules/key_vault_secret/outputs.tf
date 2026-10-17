output "secrets" {
  description = "Map of created Key Vault Secrets."
  value = {
    for k, v in azurerm_key_vault_secret.secret : k => {
      id             = v.id
      name           = v.name
      version        = v.version
      versionless_id = v.versionless_id
      resource_id    = v.resource_id
    }
  }
}
