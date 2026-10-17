# Azure Role Assignment Terraform Module

Enterprise child module to manage Azure Role-Based Access Control (RBAC) assignments (`azurerm_role_assignment`).

## Features

- **Flexible Scoping**: Assign roles at subscription, resource group, or individual resource scope (Key Vault, ACR, Storage, AKS, etc.).
- **Built-in & Custom Roles**: Supports either `role_definition_name` (e.g. `AcrPull`, `Contributor`, `Storage Blob Data Contributor`) or `role_definition_id`.
- **Identity Support**: Assign to Users, Groups, Service Principals, or Managed Identities.
- **Race Condition Protection**: Includes `skip_service_principal_aad_check` to prevent Azure AD propagation delays during automated CI/CD pipeline deployments.

## Usage Example

```hcl
module "role_assignment" {
  source = "../../modules/role_assignment"

  scope                = module.container_registry["primary"].id
  role_definition_name = "AcrPull"
  principal_id         = module.aks["primary"].kubelet_identity[0].object_id
}
```
