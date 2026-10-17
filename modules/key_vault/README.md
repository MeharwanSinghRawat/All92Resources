# Azure Key Vault Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Key Vault (`azurerm_key_vault`), Access Policies (`azurerm_key_vault_access_policy`), Role Assignments (`azurerm_role_assignment`), Secrets (`azurerm_key_vault_secret`), and Keys (`azurerm_key_vault_key`).

---

## Features

- **Enterprise Security**: Supports Azure RBAC authorization or discrete Access Policies.
- **Data Protection**: Soft delete retention days (7-90 days) and optional Purge Protection.
- **Network Firewall & ACLs**: Dynamic network ACLs with IP whitelists, Virtual Network Subnet IDs, and Azure service bypass.
- **Granular Secret & Key Lifecycle**: Declarative secrets and cryptographic keys managed via `for_each` maps with dependency ordering.
- **100% Parameterized**: Zero hard-coded values; decoupled from provider client configuration.

---

## Usage Example

```hcl
module "key_vault" {
  source = "../../modules/key_vault"

  name                = "kv-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enable_rbac_authorization   = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  network_acls = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["203.0.113.5/32"]
    virtual_network_subnet_ids = [module.virtual_network["spoke"].subnet_ids["app"]]
  }

  secrets = {
    db_password = {
      value        = "SuperSecretPassword123!"
      content_type = "text/plain"
    }
  }

  tags = {
    Environment = "dev"
    Tier        = "Security"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | Globally unique Key Vault name (3-24 alphanumeric and dashes). | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `tenant_id` | `string` | Azure Active Directory tenant ID. | Yes | - |
| `sku_name` | `string` | SKU tier (`standard` or `premium`). | No | `"standard"` |
| `enable_rbac_authorization` | `bool` | Enable Azure RBAC for data actions. | No | `true` |
| `purge_protection_enabled` | `bool` | Enable purge protection. | No | `false` |
| `soft_delete_retention_days` | `number` | Soft delete retention days (7-90). | No | `7` |
| `public_network_access_enabled` | `bool` | Enable public network access. | No | `true` |
| `network_acls` | `object` | Network firewall & subnet ACL configuration. | No | `null` |
| `access_policies` | `map(object)` | Map of access policies. | No | `{}` |
| `role_assignments` | `map(object)` | Map of RBAC role assignments. | No | `{}` |
| `secrets` | `map(object)` | Map of Key Vault secrets. | No | `{}` |
| `keys` | `map(object)` | Map of Key Vault keys. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `id` | Azure Resource ID of the Key Vault. |
| `name` | Name of the Key Vault. |
| `vault_uri` | URI of the Key Vault for SDK/CLI operations. |
| `resource_group_name` | Name of the Resource Group. |
| `location` | Azure region of the Key Vault. |
| `secret_ids` | Map of secret keys to versionless IDs. |
| `key_ids` | Map of cryptographic key keys to versionless IDs. |
