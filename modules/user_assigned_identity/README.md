# Azure User Assigned Managed Identity Terraform Module

Enterprise child module to manage **User Assigned Managed Identities (`azurerm_user_assigned_identity`)** and **Federated Identity Credentials (`azurerm_federated_identity_credential`)**.

## Features

- **RBAC Ready**: Exports `principal_id` for immediate binding with `modules/role_assignment`.
- **Workload Identity Support**: Supports Federated Identity Credentials for AKS Workload Identity and GitHub Actions OIDC without storing secrets.
- **Enterprise Standards**: Tagging, naming validations, and standard outputs.

## Usage Example

```hcl
module "app_identity" {
  source = "../../modules/user_assigned_identity"

  name                = "id-enterprise-dev-app-eastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"

  tags = {
    Environment = "Development"
  }
}
```
