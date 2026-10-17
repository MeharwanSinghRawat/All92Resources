# Azure Recovery Services Vault Module

This child module creates an `azurerm_recovery_services_vault` and configures automated VM backup policies using `azurerm_backup_policy_vm`.

## Features
- Centralized BCDR (Business Continuity & Disaster Recovery) vault.
- Supports LRS, GRS, and ZRS storage modes with cross-region restore.
- Granular backup policies (Daily, Weekly, Monthly retention schedules).

## Usage Example

```hcl
module "backup_vault" {
  source = "../../modules/recovery_services_vault"

  name                = "rsv-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-mgmt"
  location            = "eastus2"
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"

  vm_backup_policies = {
    daily_prod = {
      frequency             = "Daily"
      time                  = "22:00"
      retention_daily_count = 30
    }
  }

  tags = {
    Environment = "dev"
    Role        = "BackupVault"
  }
}
```
