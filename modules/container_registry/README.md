# Azure Container Registry (ACR) Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Container Registries (`azurerm_container_registry`) for storing and managing private Docker container images and related OCI artifacts.

---

## Features

- **Multi-Tier SKUs**: Supports `Basic`, `Standard`, and `Premium` SKUs.
- **Enterprise Security**: Configurable admin credentials, public network access toggle, and dynamic network IP firewall rules.
- **High Availability**: Zone redundancy and multi-region Geo-Replication support for Premium SKU.
- **Kubernetes Ready**: Exports standard login servers and credentials for seamless AKS integration and Helm deployments.

---

## Usage Example

```hcl
module "container_registry" {
  source = "../../modules/container_registry"

  name                = "acrenterprisedeveastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    Environment = "dev"
    Tier        = "ContainerPlatform"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | Globally unique ACR name (5-50 alphanumeric lowercase). | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `sku` | `string` | SKU Tier (`Basic`, `Standard`, `Premium`). | No | `"Standard"` |
| `admin_enabled` | `bool` | Enable admin user authentication. | No | `false` |
| `public_network_access_enabled` | `bool` | Enable public network access. | No | `true` |
| `zone_redundancy_enabled` | `bool` | Enable zone redundancy (Premium only). | No | `false` |
| `network_rule_set` | `object` | IP firewall rule set (Premium only). | No | `null` |
| `georeplications` | `list(object)` | List of geo-replication regions (Premium only). | No | `[]` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description | Sensitive |
| :--- | :--- | :---: |
| `id` | Azure Resource ID of the Container Registry. | No |
| `name` | Name of the Container Registry. | No |
| `login_server` | Login server URL (e.g. `myregistry.azurecr.io`). | No |
| `admin_username` | Admin username (if admin enabled). | No |
| `admin_password` | Admin password (if admin enabled). | Yes |
| `resource_group_name` | Resource Group of the Registry. | No |
| `location` | Location of the Registry. | No |
