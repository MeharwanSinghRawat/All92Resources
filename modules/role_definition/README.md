# Azure Custom Role Definition Terraform Module

Enterprise child module to create and manage **Custom Azure RBAC Role Definitions (`azurerm_role_definition`)**.

## Features

- **Granular Control**: Define explicit `actions`, `not_actions`, `data_actions`, and `not_data_actions`.
- **Flexible Assignable Scopes**: Define one or more subscriptions or management groups where the role can be applied.
- **Enterprise Standards**: Follows least-privilege security best practices.

## Usage Example

```hcl
module "custom_role" {
  source = "../../modules/role_definition"

  name        = "EnterpriseDevOpsDeployer"
  scope       = data.azurerm_subscription.current.id
  description = "Custom role with permissions to deploy container and web workloads"

  permissions = [
    {
      actions = [
        "Microsoft.Resources/subscriptions/resourceGroups/read",
        "Microsoft.ContainerService/managedClusters/read",
        "Microsoft.Web/sites/*"
      ]
      not_actions = [
        "Microsoft.Web/sites/delete"
      ]
    }
  ]
}
```
