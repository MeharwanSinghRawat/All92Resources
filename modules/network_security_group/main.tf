resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each = var.security_rules

  name                                       = coalesce(each.value.name, each.key)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  description                                = each.value.description
}

resource "azurerm_subnet_network_security_group_association" "subnet_assoc" {
  for_each = var.subnet_associations

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
}
