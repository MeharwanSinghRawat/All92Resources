resource "azurerm_lb" "lb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  sku_tier            = var.sku_tier

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                          = coalesce(frontend_ip_configuration.value.name, frontend_ip_configuration.key)
      public_ip_address_id          = frontend_ip_configuration.value.public_ip_address_id
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address != null ? "Static" : frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = frontend_ip_configuration.value.private_ip_address_version
      zones                         = frontend_ip_configuration.value.zones
    }
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "pool" {
  for_each = var.backend_address_pools

  loadbalancer_id = azurerm_lb.lb.id
  name            = coalesce(each.value.name, each.key)
}

resource "azurerm_lb_probe" "probe" {
  for_each = var.probes

  loadbalancer_id     = azurerm_lb.lb.id
  name                = coalesce(each.value.name, each.key)
  protocol            = each.value.protocol
  port                = each.value.port
  request_path        = contains(["Http", "Https"], each.value.protocol) ? each.value.request_path : null
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
  probe_threshold     = each.value.probe_threshold
}

resource "azurerm_lb_rule" "rule" {
  for_each = var.load_balancing_rules

  loadbalancer_id                = azurerm_lb.lb.id
  name                           = coalesce(each.value.name, each.key)
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = each.value.backend_address_pool_name != null ? [azurerm_lb_backend_address_pool.pool[each.value.backend_address_pool_name].id] : null
  probe_id                       = each.value.probe_name != null ? azurerm_lb_probe.probe[each.value.probe_name].id : null
  floating_ip_enabled            = each.value.enable_floating_ip
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  load_distribution              = each.value.load_distribution
  tcp_reset_enabled              = each.value.enable_tcp_reset
  disable_outbound_snat          = each.value.disable_outbound_snat
}

resource "azurerm_lb_nat_rule" "nat" {
  for_each = var.inbound_nat_rules

  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = coalesce(each.value.name, each.key)
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  floating_ip_enabled            = each.value.enable_floating_ip
  tcp_reset_enabled              = each.value.enable_tcp_reset
}
