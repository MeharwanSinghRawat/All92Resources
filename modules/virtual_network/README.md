# Azure Virtual Network Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Virtual Networks (`azurerm_virtual_network`), independent Subnets (`azurerm_subnet`), optional DDoS protection, and NSG/Route Table subnet associations.

---

## Features

- **100% `for_each` Driven**: Subnets and subnet associations are provisioned with semantic string keys.
- **Independent Subnets**: Avoids inline `subnet` block churn; subnets are defined as distinct resources.
- **Enterprise Subnet Capabilities**: Supports custom DNS, service endpoints, service endpoint policies, private endpoint policies, and subnet delegations.
- **Integrated Associations**: Supports direct declaration of Network Security Groups and Route Tables.

---

## Usage Example

```hcl
module "vnet" {
  source = "../../modules/virtual_network"

  name                = "vnet-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  address_space       = ["10.0.0.0/16"]

  subnets = {
    web = {
      name             = "snet-web"
      address_prefixes = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
    app = {
      name             = "snet-app"
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Sql"]
    }
    db = {
      name                                          = "snet-db"
      address_prefixes                              = ["10.0.3.0/24"]
      private_endpoint_network_policies             = "Enabled"
      private_link_service_network_policies_enabled = true
    }
  }

  tags = {
    Environment = "dev"
    Project     = "EnterprisePlatform"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | The name of the Virtual Network. | Yes | - |
| `resource_group_name` | `string` | Name of the parent Resource Group. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `address_space` | `list(string)` | List of CIDR address blocks. | Yes | - |
| `dns_servers` | `list(string)` | Custom DNS server IP list. | No | `[]` |
| `ddos_protection_plan` | `object` | DDoS protection plan ID and enabled flag. | No | `null` |
| `subnets` | `map(object)` | Map of subnet configurations. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `id` | The Azure Resource ID of the Virtual Network. |
| `name` | The name of the Virtual Network. |
| `resource_group_name` | The parent Resource Group name. |
| `location` | The location of the Virtual Network. |
| `address_space` | The CIDR address space. |
| `guid` | The GUID of the Virtual Network. |
| `subnet_ids` | Map of subnet keys to their Azure subnet resource IDs. |
| `subnet_names` | Map of subnet keys to their subnet names. |
| `subnets` | Full map of provisioned subnets and their attributes. |
