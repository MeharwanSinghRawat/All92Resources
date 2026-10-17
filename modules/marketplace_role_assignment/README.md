# Azure Marketplace Role Assignment Terraform Module

Enterprise child module to manage Azure Marketplace Role Assignments (`azurerm_marketplace_role_assignment`).

## Features

- **Marketplace Authorization**: Assign roles scoped specifically to Azure Marketplace publishers and offers.
- **Role Flexibility**: Supports `role_definition_name` or `role_definition_id`.
- **Condition Support**: Attribute-based access control conditions supported.

## Usage Example

```hcl
module "marketplace_role" {
  source = "../../modules/marketplace_role_assignment"

  publisher_id         = "my-publisher-id"
  principal_id         = "00000000-0000-0000-0000-000000000000"
  role_definition_name = "Marketplace Admin"
}
```
