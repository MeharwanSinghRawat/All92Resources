# Azure PIM Eligible Role Assignment Terraform Module

Enterprise child module to manage Privileged Identity Management (PIM) **Eligible Role Assignments (`azurerm_pim_eligible_role_assignment`)**.

## Features

- **Just-In-Time (JIT) Elevation**: Grants users eligible access that requires activation via Azure Portal / PIM API.
- **Scheduling**: Supports configurable eligibility start dates and expiration periods.
- **ABAC Support**: Fine-grained access conditions.

## Usage Example

```hcl
module "pim_eligible_admin" {
  source = "../../modules/pim_eligible_role_assignment"

  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/subscriptions/.../providers/Microsoft.Authorization/roleDefinitions/..."
  principal_id       = "00000000-0000-0000-0000-000000000000"
  justification      = "Eligible DevOps Administrator access"
}
```
