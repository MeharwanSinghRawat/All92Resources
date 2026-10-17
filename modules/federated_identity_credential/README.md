# Azure Federated Identity Credential Terraform Module

Enterprise child module to manage **Federated Identity Credentials (`azurerm_federated_identity_credential`)** for Azure User Assigned Managed Identities.

## Features

- **Workload Identity Federation**: Enables AKS pods and external CI/CD systems (GitHub Actions, GitLab CI) to authenticate to Azure without secrets.
- **Standards Compliant**: Full validation for OIDC issuer, audience, and subject claims.

## Usage Example

```hcl
module "aks_federated_credential" {
  source = "../../modules/federated_identity_credential"

  name                = "fed-aks-workload"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  parent_id           = module.user_assigned_identity["app_workload"].id
  issuer              = module.aks["primary"].oidc_issuer_url
  subject             = "system:serviceaccount:default:workload-sa"
}
```
