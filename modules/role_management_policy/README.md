# Azure Role Management Policy Module

This child module manages an `azurerm_role_management_policy` resource for Privileged Identity Management (PIM) in Azure.

## Features
- Configure activation rules for eligible role assignments (maximum duration, MFA requirement, approval workflow).
- Configure active assignment expiration rules and justification requirements.
- Configure eligible assignment duration and expiration rules.
- Configure granular notification alerts for admins, approvers, and assignees.

## Usage Example

```hcl
module "role_management_policy" {
  source = "../../modules/role_management_policy"

  scope              = azurerm_resource_group.rg.id
  role_definition_id = data.azurerm_role_definition.contributor.id

  activation_rules = {
    maximum_duration                   = "PT4H"
    require_approval                   = true
    require_justification              = true
    require_multifactor_authentication = true
    approval_stage = {
      primary_approver = [
        {
          object_id = "00000000-0000-0000-0000-000000000000"
          type      = "Group"
        }
      ]
    }
  }

  active_assignment_rules = {
    expire_after          = "P180D"
    require_justification = true
  }

  eligible_assignment_rules = {
    expiration_required = false
  }
}
```
