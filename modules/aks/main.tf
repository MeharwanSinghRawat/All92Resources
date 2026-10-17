resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = coalesce(var.dns_prefix, var.name)
  kubernetes_version        = var.kubernetes_version
  sku_tier                  = var.sku_tier
  private_cluster_enabled   = var.private_cluster_enabled
  workload_identity_enabled = var.workload_identity_enabled
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  node_resource_group       = var.node_resource_group

  default_node_pool {
    name                         = try(var.default_node_pool.name, "system")
    vm_size                      = try(var.default_node_pool.vm_size, "Standard_D2s_v5")
    node_count                   = try(var.default_node_pool.enable_auto_scaling, false) ? null : try(var.default_node_pool.node_count, 1)
    auto_scaling_enabled         = try(var.default_node_pool.enable_auto_scaling, false)
    min_count                    = try(var.default_node_pool.enable_auto_scaling, false) ? var.default_node_pool.min_count : null
    max_count                    = try(var.default_node_pool.enable_auto_scaling, false) ? var.default_node_pool.max_count : null
    os_disk_size_gb              = try(var.default_node_pool.os_disk_size_gb, 30)
    os_disk_type                 = try(var.default_node_pool.os_disk_type, "Managed")
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = try(var.default_node_pool.zones, [])
    node_labels                  = try(var.default_node_pool.node_labels, {})
    only_critical_addons_enabled = try(var.default_node_pool.only_critical_addons_enabled, false)
    temporary_name_for_rotation  = try(var.default_node_pool.temporary_name_for_rotation, "systemtmp")
    tags                         = merge(var.tags, try(var.default_node_pool.tags, {}))
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? [var.user_assigned_identity_id] : null
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_plugin_mode = var.network_profile.network_plugin_mode
    network_policy      = var.network_profile.network_policy
    dns_service_ip      = var.network_profile.dns_service_ip
    service_cidr        = var.network_profile.service_cidr
    pod_cidr            = var.network_profile.pod_cidr
    load_balancer_sku   = var.network_profile.load_balancer_sku
    outbound_type       = var.network_profile.outbound_type
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control != null ? [var.azure_active_directory_role_based_access_control] : []
    content {
      azure_rbac_enabled     = try(azure_active_directory_role_based_access_control.value.azure_rbac_enabled, true)
      admin_group_object_ids = try(azure_active_directory_role_based_access_control.value.admin_group_object_ids, null)
      tenant_id              = try(azure_active_directory_role_based_access_control.value.tenant_id, null)
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? [1] : []
    content {
      secret_rotation_enabled = var.secret_rotation_enabled
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings,
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each = var.node_pools

  name                  = coalesce(each.value.name, each.key)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = try(each.value.vm_size, "Standard_D2s_v5")
  auto_scaling_enabled  = try(each.value.enable_auto_scaling, false)
  node_count            = try(each.value.enable_auto_scaling, false) ? null : try(each.value.node_count, 1)
  min_count             = try(each.value.enable_auto_scaling, false) ? each.value.min_count : null
  max_count             = try(each.value.enable_auto_scaling, false) ? each.value.max_count : null
  os_disk_size_gb       = try(each.value.os_disk_size_gb, 30)
  os_disk_type          = try(each.value.os_disk_type, "Managed")
  vnet_subnet_id        = each.value.vnet_subnet_id
  mode                  = try(each.value.mode, "User")
  zones                 = try(each.value.zones, [])
  node_labels           = try(each.value.node_labels, {})
  node_taints           = try(each.value.node_taints, [])
  tags                  = merge(var.tags, try(each.value.tags, {}))
}
