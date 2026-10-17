# Azure Kubernetes Service (AKS) Terraform Child Module

A production-grade, generic Terraform child module to provision Managed Kubernetes Clusters (`azurerm_kubernetes_cluster`) and secondary Worker Node Pools (`azurerm_kubernetes_cluster_node_pool`).

---

## Features

- **Enterprise Governance**: Supports Azure AD RBAC (`azure_rbac_enabled`), Workload Identity, and OIDC issuer.
- **Advanced Networking**: Built with Azure CNI (`network_plugin = "azure"`), Azure Network Policy, and configurable service CIDRs.
- **Node Pool Flexibility**: Fully configurable system node pool and secondary user worker node pools with auto-scaling (`auto_scaling_enabled`), multi-zone placement, and custom VM sizes.
- **Addons & Extensions**: Optional Key Vault Secrets Provider CSI driver (`key_vault_secrets_provider`) and automated secret rotation.
- **Zero Hardcoding**: Subnets, identities, regions, and cluster versions are fully parameterized.

---

## Usage Example

```hcl
module "aks" {
  source = "../../modules/aks"

  name                = "aks-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  sku_tier            = "Free"

  default_node_pool = {
    name                = "system"
    vm_size             = "Standard_D2s_v5"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    vnet_subnet_id      = module.virtual_network["spoke"].subnet_ids["app"]
  }

  node_pools = {
    workload = {
      name                = "workload"
      vm_size             = "Standard_D4s_v5"
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 5
      vnet_subnet_id      = module.virtual_network["spoke"].subnet_ids["app"]
      node_labels = {
        role = "application"
      }
    }
  }

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
| `name` | `string` | The name of the AKS managed cluster (2-63 chars). | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `default_node_pool` | `object` | System node pool configuration. | Yes | - |
| `dns_prefix` | `string` | DNS prefix for cluster FQDN. | No | `var.name` |
| `kubernetes_version` | `string` | Specific Kubernetes version. | No | `null` |
| `sku_tier` | `string` | SLA Tier (`Free`, `Standard`, `Premium`). | No | `"Free"` |
| `private_cluster_enabled` | `bool` | Enable private cluster API endpoint. | No | `false` |
| `workload_identity_enabled` | `bool` | Enable Azure AD Workload Identity. | No | `true` |
| `oidc_issuer_enabled` | `bool` | Enable OIDC Issuer. | No | `true` |
| `identity_type` | `string` | Identity type (`SystemAssigned`/`UserAssigned`). | No | `"SystemAssigned"` |
| `network_profile` | `object` | CNI and routing configuration. | No | `{...}` |
| `azure_active_directory_role_based_access_control` | `object` | Azure RBAC integration settings. | No | `{...}` |
| `key_vault_secrets_provider_enabled` | `bool` | Enable Key Vault CSI driver addon. | No | `false` |
| `node_pools` | `map(object)` | Additional user worker node pools. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description | Sensitive |
| :--- | :--- | :---: |
| `id` | Azure Resource ID of the AKS cluster. | No |
| `name` | Name of the Managed Kubernetes Cluster. | No |
| `fqdn` | Kubernetes API Server FQDN. | No |
| `oidc_issuer_url` | OpenID Connect Issuer URL for federated credentials. | No |
| `kube_config_raw` | Raw Kubeconfig for cluster access. | Yes |
| `kube_admin_config_raw` | Admin Kubeconfig for cluster access. | Yes |
| `identity_principal_id` | System-assigned identity principal ID. | No |
| `kubelet_identity_object_id` | Kubelet user-assigned identity object ID (for ACR pull). | No |
| `node_resource_group` | Auto-generated MC_ resource group name. | No |
| `node_pool_ids` | Map of user node pool keys to their resource IDs. | No |
