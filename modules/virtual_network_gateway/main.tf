resource "azurerm_virtual_network_gateway" "gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = var.type
  vpn_type            = var.vpn_type
  sku                 = var.sku
  generation          = var.generation
  active_active       = var.active_active
  enable_bgp          = var.enable_bgp
  tags                = var.tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.active_active && var.secondary_public_ip_address_id != null ? [1] : []
    content {
      name                          = "vnetGatewayConfigSecondary"
      public_ip_address_id          = var.secondary_public_ip_address_id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = var.subnet_id
    }
  }

  dynamic "bgp_settings" {
    for_each = var.enable_bgp && var.bgp_settings != null ? [var.bgp_settings] : []
    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    content {
      address_space        = vpn_client_configuration.value.address_space
      vpn_client_protocols = vpn_client_configuration.value.vpn_client_protocols

      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value.root_certificate
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }
    }
  }
}

resource "azurerm_local_network_gateway" "local_gw" {
  for_each = var.local_network_gateways

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = each.value.gateway_address
  gateway_fqdn        = each.value.gateway_fqdn
  address_space       = each.value.address_spaces
  tags                = merge(var.tags, try(each.value.tags, {}))

  dynamic "bgp_settings" {
    for_each = each.value.bgp_settings != null ? [each.value.bgp_settings] : []
    content {
      asn                 = bgp_settings.value.asn
      bgp_peering_address = bgp_settings.value.bgp_peering_address
      peer_weight         = bgp_settings.value.peer_weight
    }
  }
}

resource "azurerm_virtual_network_gateway_connection" "conn" {
  for_each = var.connections

  name                            = each.key
  location                        = var.location
  resource_group_name             = var.resource_group_name
  type                            = each.value.type
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.gateway.id
  local_network_gateway_id        = each.value.local_network_gateway_name != null ? azurerm_local_network_gateway.local_gw[each.value.local_network_gateway_name].id : null
  peer_virtual_network_gateway_id = each.value.peer_virtual_network_gateway_id
  shared_key                      = each.value.shared_key
  enable_bgp                      = each.value.enable_bgp
  tags                            = merge(var.tags, try(each.value.tags, {}))

  dynamic "ipsec_policy" {
    for_each = each.value.ipsec_policy != null ? [each.value.ipsec_policy] : []
    content {
      dh_group         = ipsec_policy.value.dh_group
      ike_encryption   = ipsec_policy.value.ike_encryption
      ike_integrity    = ipsec_policy.value.ike_integrity
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity  = ipsec_policy.value.ipsec_integrity
      pfs_group        = ipsec_policy.value.pfs_group
      sa_datasize      = ipsec_policy.value.sa_datasize
      sa_lifetime      = ipsec_policy.value.sa_lifetime
    }
  }
}
