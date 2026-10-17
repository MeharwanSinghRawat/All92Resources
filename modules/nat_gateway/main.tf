resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "pip_assoc" {
  for_each = toset(var.public_ip_address_ids)

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = each.value
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "prefix_assoc" {
  for_each = toset(var.public_ip_prefix_ids)

  nat_gateway_id      = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id = each.value
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  for_each = var.subnet_ids

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
