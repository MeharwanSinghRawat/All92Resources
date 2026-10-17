resource "azurerm_public_ip" "pip" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  allocation_method       = var.allocation_method
  sku                     = var.sku
  sku_tier                = var.sku_tier
  zones                   = length(var.zones) > 0 ? var.zones : null
  ip_version              = var.ip_version
  domain_name_label       = var.domain_name_label
  reverse_fqdn            = var.reverse_fqdn
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  public_ip_prefix_id     = var.public_ip_prefix_id
  ddos_protection_mode    = var.ddos_protection_mode
  ddos_protection_plan_id = var.ddos_protection_plan_id

  tags = var.tags
}
