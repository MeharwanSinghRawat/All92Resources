# Azure Virtual Machine Terraform Child Module

A production-grade, generic Terraform child module to provision Linux (`azurerm_linux_virtual_machine`) and Windows (`azurerm_windows_virtual_machine`) Virtual Machines with attached Network Interfaces (`azurerm_network_interface`), optional Public IPs (`azurerm_public_ip`), and Managed Data Disks (`azurerm_managed_disk`).

---

## Features

- **Dual OS Support**: Supports both `Linux` (SSH key or password authentication) and `Windows` (admin password authentication).
- **Network Configuration**: Subnet binding, static/dynamic private IP allocation, and optional Public IP.
- **Data Disk Attachments**: Declaratively attach multiple managed data disks via `for_each` maps with custom LUN ordering.
- **Enterprise Security**: System-Assigned or User-Assigned Managed Identity and configurable OS disk caching/storage tier.

---

## Usage Example

```hcl
module "vm_jumpbox" {
  source = "../../modules/virtual_machine"

  name                = "vm-ent-dev-jumpbox"
  resource_group_name = "rg-enterprise-dev-app-eastus2"
  location            = "eastus2"
  os_type             = "Linux"
  size                = "Standard_D2s_v6"
  admin_username      = "azureuser"
  admin_ssh_key       = file("~/.ssh/id_rsa.pub")
  subnet_id           = module.virtual_network["spoke"].subnet_ids["app"]

  enable_public_ip = false

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
  }

  tags = {
    Environment = "dev"
    Role        = "Jumpbox"
    ManagedBy   = "Terraform"
  }
}
```

---

## Inputs

| Name | Type | Description | Required | Default |
| :--- | :--- | :--- | :---: | :--- |
| `name` | `string` | Virtual Machine name. | Yes | - |
| `resource_group_name` | `string` | Parent Resource Group name. | Yes | - |
| `location` | `string` | Azure region. | Yes | - |
| `subnet_id` | `string` | Subnet ID for the primary NIC. | Yes | - |
| `os_type` | `string` | OS type (`Linux` or `Windows`). | No | `"Linux"` |
| `size` | `string` | VM SKU tier (e.g. `Standard_D2s_v6`). | No | `"Standard_D2s_v6"` |
| `admin_username` | `string` | Local admin username. | No | `"azureuser"` |
| `admin_password` | `string` | Admin password (sensitive). | No | `null` |
| `admin_ssh_key` | `string` | Public SSH Key (for Linux). | No | `null` |
| `enable_public_ip` | `bool` | Create and attach a public IP. | No | `false` |
| `os_disk` | `object` | OS Disk settings. | No | `{...}` |
| `source_image_reference` | `object` | Source OS marketplace image. | No | `{...}` |
| `data_disks` | `map(object)` | Map of managed data disks. | No | `{}` |
| `tags` | `map(string)` | Resource tags. | No | `{}` |

---

## Outputs

| Name | Description | Sensitive |
| :--- | :--- | :---: |
| `id` | Azure Resource ID of the Virtual Machine. | No |
| `name` | Name of the Virtual Machine. | No |
| `network_interface_id` | ID of the primary network interface. | No |
| `private_ip_address` | Primary private IP address. | No |
| `public_ip_address` | Public IP address (if enabled). | No |
| `identity_principal_id` | System-assigned identity principal ID. | No |
| `data_disk_ids` | Map of attached data disk IDs. | No |
