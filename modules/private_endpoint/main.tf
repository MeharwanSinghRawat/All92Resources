resource "azurerm_private_endpoint" "pe" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.custom_network_interface_name

  private_service_connection {
    name                           = "${var.name}-connection"
    private_connection_resource_id = var.target_resource_id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
    request_message                = var.is_manual_connection ? var.request_message : null
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group != null ? [var.private_dns_zone_group] : []
    content {
      name                 = try(private_dns_zone_group.value.name, "default")
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }

  tags = var.tags
}
