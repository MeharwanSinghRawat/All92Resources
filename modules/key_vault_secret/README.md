# Azure Key Vault Secret Module

This child module creates and manages secrets inside an existing Azure Key Vault using `azurerm_key_vault_secret`.

## Features
- Store sensitive connection strings, API tokens, and credentials securely.
- Content-type annotation (e.g. `application/json`, `text/plain`).
- Activation (`not_before_date`) and expiration dates (`expiration_date`).

## Usage Example

```hcl
module "kv_secrets" {
  source = "../../modules/key_vault_secret"

  key_vault_id = module.key_vault.id

  secrets = {
    db_password = {
      name  = "database-admin-password"
      value = "SuperSecretP@ssw0rd!"
    }
  }

  tags = {
    Environment = "dev"
  }
}
```
