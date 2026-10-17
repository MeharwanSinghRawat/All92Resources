# Azure Policy Assignment Module

This child module manages policy assignments at either Subscription or Resource Group scopes using `azurerm_subscription_policy_assignment` or `azurerm_resource_group_policy_assignment`.

## Features
- Assign policies or policy initiatives at Subscription or Resource Group level.
- Supports remediation via Managed Identity (SystemAssigned or UserAssigned).
- Configurable parameters and non-compliance messages.

## Usage Example

```hcl
module "assign_tagging" {
  source = "../../modules/policy_assignment"

  name                 = "assign-mandatory-tags"
  scope_type           = "subscription"
  subscription_id      = "/subscriptions/00000000-0000-0000-0000-000000000000"
  policy_definition_id = module.policy_definition.id
  display_name         = "Enforce Mandatory Environment Tags"

  non_compliance_messages = [
    {
      content = "All resources must include an Environment tag."
    }
  ]
}
```
