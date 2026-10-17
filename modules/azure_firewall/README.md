# Azure Firewall Child Module

This production-grade Terraform module provisions and manages an **Azure Firewall (Standard / Premium / Basic)** integrated with modern **Azure Firewall Policies**, **Rule Collection Groups**, and dedicated Static Standard Public IP.

---

## Features

- **Modern Firewall Policy Integration**: Manages `azurerm_firewall_policy` and `azurerm_firewall_policy_rule_collection_group`.
- **Flexible Rules Engine**: Network Rules, Application Rules (FQDN filtering), and NAT / DNAT rules supported.
- **Threat Intelligence & DNS**: Configurable Threat Intel modes (`Alert`, `Deny`, `Off`) and DNS Proxy.
- **Dedicated Public IP**: Automatic creation of Standard Static Public IP.
- **Zero-touch Integration**: Plugs seamlessly into Hub-and-Spoke architectures with predefined `AzureFirewallSubnet`.

---

## Usage Example

```hcl
module "azure_firewall" {
  source = "../../modules/azure_firewall"

  name                = "afw-enterprise-dev-eastus2"
  resource_group_name = "rg-enterprise-dev-network-eastus2"
  location            = "eastus2"
  subnet_id           = module.virtual_network["hub"].subnet_ids["firewall"]
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  threat_intel_mode   = "Alert"

  network_rule_collections = {
    allow_internal = {
      priority = 200
      action   = "Allow"
      rules = {
        allow_dns = {
          protocols         = ["UDP"]
          destination_ports = ["53"]
          source_addresses  = ["10.0.0.0/8"]
          destination_addresses = ["*"]
        }
      }
    }
  }

  application_rule_collections = {
    allow_web = {
      priority = 300
      action   = "Allow"
      rules = {
        allow_microsoft = {
          source_addresses  = ["10.20.0.0/16"]
          destination_fqdns = ["*.microsoft.com", "*.azure.com"]
        }
      }
    }
  }

  tags = {
    Environment = "Development"
  }
}
```
