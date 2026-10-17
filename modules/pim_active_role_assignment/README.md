# Azure PIM Active Role Assignment Terraform Module

Enterprise child module to manage Privileged Identity Management (PIM) **Active Role Assignments (`azurerm_pim_active_role_assignment`)**.

## Features

- **Time-Bound Privileges**: Supports explicit start dates and durations (hours/days/end date).
- **Audit & Compliance**: Allows attaching justifications and ticketing system identifiers (ITIL ticket numbers).
- **Zero-Trust Ready**: Ensures high-privilege access is granted directly through PIM.

## Usage Example

```hcl
module "pim_active_role" {
  source = "../../modules/pim_active_role_assignment"

  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/subscriptions/.../providers/Microsoft.Authorization/roleDefinitions/..."
  principal_id       = "00000000-0000-0000-0000-000000000000"
  justification      = "Emergency operational maintenance"

  schedule = {
    start_date_time = "2026-10-12T12:00:00Z"
    expiration = {
      duration_hours = 8
    }
  }
}
```
