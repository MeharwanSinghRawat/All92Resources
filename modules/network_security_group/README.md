# Azure Network Security Group Terraform Child Module

A production-grade, generic Terraform child module to provision Azure Network Security Groups (`azurerm_network_security_group`), discrete Security Rules (`azurerm_network_security_rule`), and optional Subnet Associations (`azurerm_subnet_network_security_group_association`).

---

## Features

- **100% `for_each` Architecture**: Zero `count` usage; all security rules and subnet associations use stable semantic keys.
- **Discrete Rules**: Avoids inline `security_rule` churn; allows seamless updates and granular plans.
- **Multi-Port & CIDR Support**: Supports single and multiple port ranges, CIDR blocks, Service Tags, and Application Security Groups (ASGs).
- **Subnet Association**: Optionally links the NSG directly to subnet IDs.

---

## Usage Example

```hcl
module "nsg_web" {
  source = "../../modules/network_security_group"

  name                = "nsg-enterprise-dev-web-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"

  security_rules = {
    allow_https = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
      description                = "Allow HTTPS inbound from Internet"
    }
    allow_http = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
      description                = "Allow HTTP inbound from Internet"
    }
  }

  subnet_associations = {
    web_subnet = module.virtual_network["spoke"].subnet_ids["web"]
  }

  tags = {
    Environment = "dev"
    Tier        = "Web"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | The name of the Network Security Group. | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `security_rules` | `map(object)` | Map of security rules to configure. | No | `{}` |
| `subnet_associations` | `map(string)` | Map of subnet IDs to associate with this NSG. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `id` | Azure Resource ID of the Network Security Group. |
| `name` | Name of the Network Security Group. |
| `resource_group_name` | Name of the Resource Group. |
| `location` | Region of the Network Security Group. |
| `security_rule_ids` | Map of security rule keys to their Azure IDs. |
