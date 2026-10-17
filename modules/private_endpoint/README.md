# Azure Private Endpoint Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Private Endpoints (`azurerm_private_endpoint`) for secure, private connectivity to PaaS services (such as Azure Storage Account, Azure Key Vault, Azure SQL, Cosmos DB, and Container Registries).

---

## Features

- **PaaS Agnostic**: Connects to any Azure PaaS resource via `target_resource_id` and `subresource_names`.
- **Private DNS Integration**: Optional `private_dns_zone_group` block to automatically register DNS records in Azure Private DNS Zones.
- **Static & Dynamic IP Allocation**: Supports dynamic IP assignment by default or custom `ip_configurations` for static private IP reservation.
- **Approval Workflows**: Configurable manual connection mode (`is_manual_connection`) for cross-tenant or restricted resources.
- **Custom NIC Naming**: Supports `custom_network_interface_name` to maintain enterprise naming conventions.

---

## Usage Example

```hcl
module "private_endpoint_storage" {
  source = "../../modules/private_endpoint"

  name                = "pe-stentdevdata001-blob"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  subnet_id           = module.virtual_network["spoke"].subnet_ids["data"]

  target_resource_id = module.storage_account["data_store"].id
  subresource_names  = ["blob"]

  tags = {
    Environment = "dev"
    Tier        = "Data"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | The name of the Private Endpoint (2-80 chars). | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `subnet_id` | `string` | Subnet ID to attach the Private Endpoint. | Yes | - |
| `target_resource_id` | `string` | Target PaaS resource ID. | Yes | - |
| `subresource_names` | `list(string)` | Target subresource names (e.g. `blob`, `vault`). | Yes | - |
| `is_manual_connection` | `bool` | Whether manual approval is required. | No | `false` |
| `request_message` | `string` | Message for manual approval request. | No | `null` |
| `custom_network_interface_name` | `string` | Custom name for the auto-created NIC. | No | `null` |
| `private_dns_zone_group` | `object` | Private DNS Zone Group configuration. | No | `null` |
| `ip_configurations` | `list(object)` | List of static IP configurations. | No | `[]` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `id` | Azure Resource ID of the Private Endpoint. |
| `name` | Name of the Private Endpoint. |
| `resource_group_name` | Resource Group of the Private Endpoint. |
| `location` | Location of the Private Endpoint. |
| `network_interface_ids` | IDs of the associated network interfaces. |
| `custom_dns_configs` | Custom DNS configs associated with the endpoint. |
| `private_dns_zone_configs` | Private DNS zone configs associated with the endpoint. |
