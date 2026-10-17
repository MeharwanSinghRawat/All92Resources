# Azure Policy Definition Module

This child module creates and manages custom `azurerm_policy_definition` resources for Azure Governance and Compliance.

## Features
- Define custom compliance rules at Management Group or Subscription level.
- Supports parameters, metadata, and dynamic policy rules.
- Compatible with Azure Landing Zone CIS / ISO / NIST governance benchmarks.

## Usage Example

```hcl
module "tagging_policy" {
  source = "../../modules/policy_definition"

  name         = "audit-mandatory-tags"
  display_name = "Audit Mandatory Environment Tags"
  description  = "Audits resources missing the Environment tag"
  policy_type  = "Custom"
  mode         = "Indexed"

  policy_rule = jsonencode({
    if = {
      field = "tags['Environment']"
      exists = "false"
    }
    then = {
      effect = "audit"
    }
  })
}
```
