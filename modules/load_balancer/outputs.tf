output "id" {
  description = "The ID of the Load Balancer."
  value       = azurerm_lb.lb.id
}

output "name" {
  description = "The Name of the Load Balancer."
  value       = azurerm_lb.lb.name
}

output "frontend_ip_configuration" {
  description = "The Frontend IP Configuration block of the Load Balancer."
  value       = azurerm_lb.lb.frontend_ip_configuration
}

output "backend_address_pool_ids" {
  description = "Map of Backend Address Pool names to their Resource IDs."
  value = {
    for k, v in azurerm_lb_backend_address_pool.pool : k => v.id
  }
}

output "probe_ids" {
  description = "Map of Health Probe names to their Resource IDs."
  value = {
    for k, v in azurerm_lb_probe.probe : k => v.id
  }
}

output "rule_ids" {
  description = "Map of Load Balancing Rule names to their Resource IDs."
  value = {
    for k, v in azurerm_lb_rule.rule : k => v.id
  }
}

output "nat_rule_ids" {
  description = "Map of Inbound NAT Rule names to their Resource IDs."
  value = {
    for k, v in azurerm_lb_nat_rule.nat : k => v.id
  }
}
