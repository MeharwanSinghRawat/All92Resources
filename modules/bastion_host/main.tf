resource "azurerm_bastion_host" "bastion" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  scale_units         = var.sku != "Basic" ? var.scale_units : 2

  copy_paste_enabled        = var.copy_paste_enabled
  file_copy_enabled         = var.sku != "Basic" ? var.file_copy_enabled : false
  ip_connect_enabled        = var.sku != "Basic" ? var.ip_connect_enabled : false
  shareable_link_enabled    = var.sku != "Basic" ? var.shareable_link_enabled : false
  tunneling_enabled         = var.sku != "Basic" ? var.tunneling_enabled : false
  session_recording_enabled = var.sku == "Premium" ? var.session_recording_enabled : false
  kerberos_enabled          = var.sku != "Basic" ? var.kerberos_enabled : false

  zones = length(var.zones) > 0 ? var.zones : null

  ip_configuration {
    name                 = coalesce(var.ip_configuration_name, "${var.name}-ipconf")
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_id
  }

  tags = var.tags
}
