output "id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  description = "The Name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "resource_group_name" {
  description = "The Resource Group Name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.resource_group_name
}

output "location" {
  description = "The Location of the Virtual Network."
  value       = azurerm_virtual_network.vnet.location
}

output "address_space" {
  description = "The Address Space of the Virtual Network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "guid" {
  description = "The GUID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.guid
}

output "subnet_ids" {
  description = "Map of subnet keys to their corresponding Azure resource IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "Map of subnet keys to their corresponding names."
  value       = { for k, v in azurerm_subnet.subnets : k => v.name }
}

output "subnets" {
  description = "Full map of provisioned subnets and their attributes."
  value = {
    for k, v in azurerm_subnet.subnets : k => {
      id               = v.id
      name             = v.name
      address_prefixes = v.address_prefixes
    }
  }
}
