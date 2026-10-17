# Azure Resource Group Terraform Child Module

A production-grade, generic Terraform child module to provision an Azure Resource Group (`azurerm_resource_group`) with optional Azure Management Lock (`azurerm_management_lock`) and RBAC role assignments (`azurerm_role_assignment`).

---

## Features

- **100% `for_each` Architecture**: Zero usage of `count`, preventing index-shift destruction risks.
- **Generic & Modular**: Works across any Azure subscription and region.
- **Optional Resource Lock**: Supports `CanNotDelete` and `ReadOnly` locks with declarative string keys.
- **RBAC Assignments**: Supports declarative Role-Based Access Control assignments at the Resource Group scope.
- **Tag Merging**: Easily combines resource-specific tags with organizational baseline tags.

---

## Usage Examples

### Single Module Invocation
```hcl
module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-core-dev-eastus2"
  location = "eastus2"

  lock_level = "CanNotDelete"
  lock_notes = "Prevent accidental deletion of dev core resource group"

  tags = {
    Environment = "dev"
    Project     = "CoreInfrastructure"
    ManagedBy   = "Terraform"
  }
}
```

### Multi-Instance Invocation with `for_each` (Recommended Parent Pattern)
```hcl
module "resource_group" {
  for_each = var.resource_groups
  source   = "../../modules/resource_group"

  name       = each.value.name
  location   = each.value.location
  lock_level = each.value.lock_level
  tags       = each.value.tags
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | The name of the Resource Group. | Yes | - |
| `location` | `string` | The Azure region where the Resource Group should be created. | Yes | - |
| `tags` | `map(string)` | Key-value tags to apply to the Resource Group. | No | `{}` |
| `lock_level` | `string` | Management lock level (`CanNotDelete` or `ReadOnly`). | No | `null` |
| `lock_notes` | `string` | Informational notes describing the lock. | No | `"Managed by Terraform"` |
| `role_assignments` | `map(object)` | Map of role assignments scoped to the Resource Group. | No | `{}` |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `id` | The Azure Resource Manager ID of the Resource Group. |
| `name` | The name of the Resource Group. |
| `location` | The location / Azure region of the Resource Group. |
| `tags` | The applied tags. |
| `lock_id` | The ID of the management lock if configured. |
