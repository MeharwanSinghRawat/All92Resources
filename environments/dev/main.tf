locals {
  environment_tags = merge(
    var.common_tags,
    {
      Environment     = var.environment
      Project         = var.project_name
      PrimaryLocation = var.location
    }
  )
}

module "resource_group" {
  for_each = var.resource_groups
  source   = "../../modules/resource_group"

  name       = each.value.name
  location   = each.value.location
  lock_level = each.value.lock_level
  lock_notes = try(each.value.lock_notes, "Managed by Terraform")
  tags       = merge(local.environment_tags, try(each.value.tags, {}))
}

module "virtual_network" {
  for_each = var.virtual_networks
  source   = "../../modules/virtual_network"

  name                 = each.value.name
  resource_group_name  = module.resource_group[each.value.resource_group_key].name
  location             = module.resource_group[each.value.resource_group_key].location
  address_space        = each.value.address_space
  dns_servers          = each.value.dns_servers
  ddos_protection_plan = each.value.ddos_protection_plan
  subnets              = each.value.subnets
  tags                 = merge(local.environment_tags, try(each.value.tags, {}))
}

module "network_security_group" {
  for_each = var.network_security_groups
  source   = "../../modules/network_security_group"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  location            = module.resource_group[each.value.resource_group_key].location
  security_rules      = each.value.security_rules
  subnet_associations = {
    for k, v in each.value.subnet_associations :
    k => module.virtual_network[v.vnet_key].subnet_ids[v.subnet_key]
  }
  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "storage_account" {
  for_each = var.storage_accounts
  source   = "../../modules/storage_account"

  name                            = each.value.name
  resource_group_name             = module.resource_group[each.value.resource_group_key].name
  location                        = module.resource_group[each.value.resource_group_key].location
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  account_kind                    = each.value.account_kind
  min_tls_version                 = each.value.min_tls_version
  public_network_access_enabled   = each.value.public_network_access_enabled
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  is_hns_enabled                  = each.value.is_hns_enabled
  blob_versioning_enabled         = each.value.blob_versioning_enabled
  blob_delete_retention_days      = each.value.blob_delete_retention_days
  container_delete_retention_days = each.value.container_delete_retention_days

  network_rules = each.value.network_rules != null ? {
    default_action = each.value.network_rules.default_action
    ip_rules       = try(each.value.network_rules.ip_rules, [])
    virtual_network_subnet_ids = concat(
      try(each.value.network_rules.virtual_network_subnet_ids, []),
      [
        for sub in try(each.value.network_rules.subnet_references, []) :
        module.virtual_network[sub.vnet_key].subnet_ids[sub.subnet_key]
      ]
    )
    bypass = try(each.value.network_rules.bypass, ["AzureServices"])
  } : null

  containers  = each.value.containers
  file_shares = each.value.file_shares
  tags        = merge(local.environment_tags, try(each.value.tags, {}))
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "key_vault" {
  for_each = var.key_vaults
  source   = "../../modules/key_vault"

  name                            = each.value.name
  resource_group_name             = module.resource_group[each.value.resource_group_key].name
  location                        = module.resource_group[each.value.resource_group_key].location
  sku_name                        = each.value.sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enable_rbac_authorization       = each.value.enable_rbac_authorization
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  public_network_access_enabled   = each.value.public_network_access_enabled

  network_acls = each.value.network_acls != null ? {
    bypass         = try(each.value.network_acls.bypass, "AzureServices")
    default_action = each.value.network_acls.default_action
    ip_rules       = try(each.value.network_acls.ip_rules, [])
    virtual_network_subnet_ids = concat(
      try(each.value.network_acls.virtual_network_subnet_ids, []),
      [
        for sub in try(each.value.network_acls.subnet_references, []) :
        module.virtual_network[sub.vnet_key].subnet_ids[sub.subnet_key]
      ]
    )
  } : null

  access_policies  = each.value.access_policies
  role_assignments = each.value.role_assignments
  secrets          = each.value.secrets
  keys             = each.value.keys
  tags             = merge(local.environment_tags, try(each.value.tags, {}))
}

module "private_endpoint" {
  for_each = var.private_endpoints
  source   = "../../modules/private_endpoint"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  location            = module.resource_group[each.value.resource_group_key].location
  subnet_id           = module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key]

  target_resource_id = (
    each.value.target_type == "storage_account" ? module.storage_account[each.value.target_key].id :
    each.value.target_type == "key_vault" ? module.key_vault[each.value.target_key].id :
    each.value.custom_target_resource_id
  )

  subresource_names             = each.value.subresource_names
  is_manual_connection          = each.value.is_manual_connection
  request_message               = each.value.request_message
  custom_network_interface_name = each.value.custom_network_interface_name
  private_dns_zone_group        = each.value.private_dns_zone_group
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "aks" {
  for_each = var.aks_clusters
  source   = "../../modules/aks"

  name                               = each.value.name
  resource_group_name                = module.resource_group[each.value.resource_group_key].name
  location                           = module.resource_group[each.value.resource_group_key].location
  dns_prefix                         = each.value.dns_prefix
  kubernetes_version                 = each.value.kubernetes_version
  sku_tier                           = each.value.sku_tier
  private_cluster_enabled            = each.value.private_cluster_enabled
  workload_identity_enabled          = each.value.workload_identity_enabled
  oidc_issuer_enabled                = each.value.oidc_issuer_enabled
  node_resource_group                = each.value.node_resource_group
  identity_type                      = each.value.identity_type
  user_assigned_identity_id          = each.value.user_assigned_identity_id
  key_vault_secrets_provider_enabled = each.value.key_vault_secrets_provider_enabled
  secret_rotation_enabled            = each.value.secret_rotation_enabled

  default_node_pool = {
    name                         = each.value.default_node_pool.name
    vm_size                      = each.value.default_node_pool.vm_size
    node_count                   = each.value.default_node_pool.node_count
    enable_auto_scaling          = each.value.default_node_pool.enable_auto_scaling
    min_count                    = each.value.default_node_pool.min_count
    max_count                    = each.value.default_node_pool.max_count
    os_disk_size_gb              = each.value.default_node_pool.os_disk_size_gb
    os_disk_type                 = each.value.default_node_pool.os_disk_type
    vnet_subnet_id               = each.value.default_node_pool.vnet_key != null && each.value.default_node_pool.subnet_key != null ? module.virtual_network[each.value.default_node_pool.vnet_key].subnet_ids[each.value.default_node_pool.subnet_key] : null
    zones                        = each.value.default_node_pool.zones
    node_labels                  = each.value.default_node_pool.node_labels
    node_taints                  = each.value.default_node_pool.node_taints
    only_critical_addons_enabled = each.value.default_node_pool.only_critical_addons_enabled
    temporary_name_for_rotation  = each.value.default_node_pool.temporary_name_for_rotation
    tags                         = try(each.value.default_node_pool.tags, {})
  }

  network_profile = each.value.network_profile

  node_pools = {
    for np_k, np_v in each.value.node_pools :
    np_k => {
      name                = np_v.name
      vm_size             = np_v.vm_size
      enable_auto_scaling = np_v.enable_auto_scaling
      node_count          = np_v.node_count
      min_count           = np_v.min_count
      max_count           = np_v.max_count
      os_disk_size_gb     = np_v.os_disk_size_gb
      os_disk_type        = np_v.os_disk_type
      vnet_subnet_id      = np_v.vnet_key != null && np_v.subnet_key != null ? module.virtual_network[np_v.vnet_key].subnet_ids[np_v.subnet_key] : null
      mode                = np_v.mode
      zones               = np_v.zones
      node_labels         = np_v.node_labels
      node_taints         = np_v.node_taints
      tags                = try(np_v.tags, {})
    }
  }

  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "container_registry" {
  for_each = var.container_registries
  source   = "../../modules/container_registry"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = module.resource_group[each.value.resource_group_key].location
  sku                           = each.value.sku
  admin_enabled                 = each.value.admin_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  zone_redundancy_enabled       = each.value.zone_redundancy_enabled
  export_policy_enabled         = each.value.export_policy_enabled
  network_rule_set              = each.value.network_rule_set
  georeplications               = each.value.georeplications
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "virtual_machine" {
  for_each = var.virtual_machines
  source   = "../../modules/virtual_machine"

  name                            = each.value.name
  resource_group_name             = module.resource_group[each.value.resource_group_key].name
  location                        = module.resource_group[each.value.resource_group_key].location
  os_type                         = each.value.os_type
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  admin_ssh_key                   = each.value.admin_ssh_key
  disable_password_authentication = each.value.disable_password_authentication
  subnet_id                       = module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key]
  private_ip_address_allocation   = each.value.private_ip_address_allocation
  private_ip_address              = each.value.private_ip_address
  public_ip_id                    = each.value.public_ip_key != null ? module.public_ip[each.value.public_ip_key].id : each.value.public_ip_id
  os_disk                         = each.value.os_disk
  source_image_reference          = each.value.source_image_reference
  data_disks                      = each.value.data_disks
  custom_data                     = each.value.custom_data
  identity_type                   = each.value.identity_type
  user_assigned_identity_ids      = each.value.user_assigned_identity_ids
  tags                            = merge(local.environment_tags, try(each.value.tags, {}))
}

module "application_gateway" {
  for_each = var.application_gateways
  source   = "../../modules/application_gateway"

  name                           = each.value.name
  resource_group_name            = module.resource_group[each.value.resource_group_key].name
  location                       = module.resource_group[each.value.resource_group_key].location
  subnet_id                      = module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key]
  sku                            = each.value.sku
  autoscale_configuration        = each.value.autoscale_configuration
  zones                          = each.value.zones
  public_ip_id                   = each.value.public_ip_key != null ? module.public_ip[each.value.public_ip_key].id : each.value.public_ip_id
  gateway_ip_configuration_name  = each.value.gateway_ip_configuration_name
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_ports                 = each.value.frontend_ports
  backend_address_pools          = each.value.backend_address_pools
  backend_http_settings          = each.value.backend_http_settings
  http_listeners                 = each.value.http_listeners
  request_routing_rules          = each.value.request_routing_rules
  probes                         = each.value.probes
  ssl_certificates               = each.value.ssl_certificates
  waf_configuration              = each.value.waf_configuration
  identity_type                  = each.value.identity_type
  user_assigned_identity_ids     = each.value.user_assigned_identity_ids
  tags                           = merge(local.environment_tags, try(each.value.tags, {}))
}

module "azure_firewall" {
  for_each = var.azure_firewalls
  source   = "../../modules/azure_firewall"

  name                         = each.value.name
  resource_group_name          = module.resource_group[each.value.resource_group_key].name
  location                     = module.resource_group[each.value.resource_group_key].location
  subnet_id                    = module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key]
  management_subnet_id         = try(module.virtual_network[each.value.vnet_key].subnet_ids[each.value.management_subnet_key], null)
  sku_name                     = each.value.sku_name
  sku_tier                     = each.value.sku_tier
  zones                        = each.value.zones
  public_ip_id                 = each.value.public_ip_key != null ? module.public_ip[each.value.public_ip_key].id : each.value.public_ip_id
  public_ip_address            = each.value.public_ip_key != null ? module.public_ip[each.value.public_ip_key].ip_address : null
  management_public_ip_id      = each.value.management_public_ip_key != null ? module.public_ip[each.value.management_public_ip_key].id : each.value.management_public_ip_id
  threat_intel_mode            = each.value.threat_intel_mode
  dns_proxy_enabled            = each.value.dns_proxy_enabled
  dns_servers                  = each.value.dns_servers
  create_firewall_policy       = each.value.create_firewall_policy
  firewall_policy_id           = each.value.firewall_policy_id
  network_rule_collections     = each.value.network_rule_collections
  application_rule_collections = each.value.application_rule_collections
  nat_rule_collections         = each.value.nat_rule_collections
  tags                         = merge(local.environment_tags, try(each.value.tags, {}))
}

module "private_dns_zone" {
  for_each = var.private_dns_zones
  source   = "../../modules/private_dns_zone"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  virtual_network_links = {
    for link_k, link_v in each.value.virtual_network_links :
    link_k => {
      name                 = link_v.name
      virtual_network_id   = module.virtual_network[link_v.vnet_key].id
      registration_enabled = link_v.registration_enabled
      tags                 = link_v.tags
    }
  }
  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "postgresql_flexible_server" {
  for_each = var.postgresql_flexible_servers
  source   = "../../modules/postgresql_flexible_server"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  location            = module.resource_group[each.value.resource_group_key].location
  server_version      = each.value.server_version
  sku_name            = each.value.sku_name
  storage_mb          = each.value.storage_mb
  storage_tier        = each.value.storage_tier
  auto_grow_enabled   = each.value.auto_grow_enabled

  backup_retention_days             = each.value.backup_retention_days
  geo_redundant_backup_enabled      = each.value.geo_redundant_backup_enabled
  create_mode                       = each.value.create_mode
  source_server_id                  = each.value.source_server_id
  point_in_time_restore_time_in_utc = each.value.point_in_time_restore_time_in_utc
  zone                              = each.value.zone

  administrator_login    = each.value.administrator_login
  administrator_password = each.value.administrator_password
  admin_password_length  = each.value.admin_password_length

  delegated_subnet_id = each.value.vnet_key != null && each.value.subnet_key != null ? module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key] : null
  private_dns_zone_id = each.value.private_dns_zone_key != null ? module.private_dns_zone[each.value.private_dns_zone_key].id : each.value.private_dns_zone_id

  public_network_access_enabled = each.value.public_network_access_enabled
  high_availability             = each.value.high_availability
  maintenance_window            = each.value.maintenance_window
  authentication                = each.value.authentication
  identity                      = each.value.identity
  customer_managed_key          = each.value.customer_managed_key

  databases             = each.value.databases
  firewall_rules        = each.value.firewall_rules
  server_configurations = each.value.server_configurations
  ad_admin              = each.value.ad_admin

  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "bastion_host" {
  for_each = var.bastion_hosts
  source   = "../../modules/bastion_host"

  name                      = each.value.name
  resource_group_name       = module.resource_group[each.value.resource_group_key].name
  location                  = module.resource_group[each.value.resource_group_key].location
  subnet_id                 = module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key]
  public_ip_id              = each.value.public_ip_key != null ? module.public_ip[each.value.public_ip_key].id : each.value.public_ip_id
  ip_configuration_name     = each.value.ip_configuration_name
  sku                       = each.value.sku
  scale_units               = each.value.scale_units
  copy_paste_enabled        = each.value.copy_paste_enabled
  file_copy_enabled         = each.value.file_copy_enabled
  ip_connect_enabled        = each.value.ip_connect_enabled
  shareable_link_enabled    = each.value.shareable_link_enabled
  tunneling_enabled         = each.value.tunneling_enabled
  session_recording_enabled = each.value.session_recording_enabled
  kerberos_enabled          = each.value.kerberos_enabled
  zones                     = each.value.zones
  tags                      = merge(local.environment_tags, try(each.value.tags, {}))
}

module "function_app" {
  for_each = var.function_apps
  source   = "../../modules/function_app"

  name                                   = each.value.name
  resource_group_name                    = module.resource_group[each.value.resource_group_key].name
  location                               = module.resource_group[each.value.resource_group_key].location
  service_plan_id                        = each.value.service_plan_id
  service_plan_name                      = each.value.service_plan_name
  sku_name                               = each.value.sku_name
  storage_account_name                   = module.storage_account[each.value.storage_account_key].name
  storage_account_access_key             = module.storage_account[each.value.storage_account_key].primary_access_key
  functions_extension_version            = each.value.functions_extension_version
  https_only                             = each.value.https_only
  public_network_access_enabled          = each.value.public_network_access_enabled
  virtual_network_subnet_id              = each.value.vnet_key != null && each.value.subnet_key != null ? module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key] : null
  vnet_route_all_enabled                 = each.value.vnet_route_all_enabled
  application_insights_connection_string = each.value.application_insights_connection_string
  application_insights_key               = each.value.application_insights_key
  identity_type                          = each.value.identity_type
  user_assigned_identity_ids             = each.value.user_assigned_identity_ids
  application_stack                      = each.value.application_stack
  app_settings                           = each.value.app_settings
  functions                              = each.value.functions
  tags                                   = merge(local.environment_tags, try(each.value.tags, {}))
}

module "monitor_workspace" {
  for_each = var.monitor_workspaces
  source   = "../../modules/monitor_workspace"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = module.resource_group[each.value.resource_group_key].location
  public_network_access_enabled = each.value.public_network_access_enabled
  prometheus_rule_groups        = each.value.prometheus_rule_groups
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "virtual_network_peering" {
  for_each = var.virtual_network_peerings
  source   = "../../modules/virtual_network_peering"

  name                         = coalesce(each.value.name, "${module.virtual_network[each.value.vnet_key].name}-to-${each.value.remote_vnet_key != null ? module.virtual_network[each.value.remote_vnet_key].name : coalesce(each.value.remote_virtual_network_name, "remote")}")
  resource_group_name          = coalesce(try(module.resource_group[each.value.resource_group_key].name, null), module.virtual_network[each.value.vnet_key].resource_group_name)
  virtual_network_name         = module.virtual_network[each.value.vnet_key].name
  use_remote_vnet_data_source  = try(each.value.use_remote_vnet_data_source, false)
  remote_virtual_network_id    = each.value.remote_vnet_key != null ? module.virtual_network[each.value.remote_vnet_key].id : each.value.remote_virtual_network_id
  remote_virtual_network_name  = each.value.remote_virtual_network_name
  remote_resource_group_name   = each.value.remote_resource_group_name
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

module "public_ip" {
  for_each = var.public_ips
  source   = "../../modules/public_ip"

  name                    = each.value.name
  resource_group_name     = module.resource_group[each.value.resource_group_key].name
  location                = module.resource_group[each.value.resource_group_key].location
  allocation_method       = each.value.allocation_method
  sku                     = each.value.sku
  sku_tier                = each.value.sku_tier
  zones                   = each.value.zones
  ip_version              = each.value.ip_version
  domain_name_label       = each.value.domain_name_label
  reverse_fqdn            = each.value.reverse_fqdn
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  public_ip_prefix_id     = each.value.public_ip_prefix_id
  ddos_protection_mode    = each.value.ddos_protection_mode
  ddos_protection_plan_id = each.value.ddos_protection_plan_id
  tags                    = merge(local.environment_tags, try(each.value.tags, {}))
}

module "service_plan" {
  for_each = var.service_plans
  source   = "../../modules/service_plan"

  name                         = each.value.name
  resource_group_name          = module.resource_group[each.value.resource_group_key].name
  location                     = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  os_type                      = each.value.os_type
  sku_name                     = each.value.sku_name
  worker_count                 = each.value.worker_count
  maximum_elastic_worker_count = each.value.maximum_elastic_worker_count
  zone_balancing_enabled       = each.value.zone_balancing_enabled
  per_site_scaling_enabled     = each.value.per_site_scaling_enabled
  tags                         = merge(local.environment_tags, try(each.value.tags, {}))
}

module "app_service" {
  for_each = var.app_services
  source   = "../../modules/app_service"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  os_type                       = each.value.os_type
  service_plan_id               = each.value.service_plan_key != null ? module.service_plan[each.value.service_plan_key].id : each.value.service_plan_id
  https_only                    = each.value.https_only
  public_network_access_enabled = each.value.public_network_access_enabled
  virtual_network_subnet_id     = each.value.vnet_key != null && each.value.subnet_key != null ? module.virtual_network[each.value.vnet_key].subnet_ids[each.value.subnet_key] : null
  vnet_route_all_enabled        = each.value.vnet_route_all_enabled
  identity_type                 = each.value.identity_type
  user_assigned_identity_ids    = each.value.user_assigned_identity_ids
  app_settings                  = each.value.app_settings
  connection_strings            = each.value.connection_strings
  application_stack             = each.value.application_stack
  site_config                   = each.value.site_config
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "load_balancer" {
  for_each = var.load_balancers
  source   = "../../modules/load_balancer"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  location            = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  sku                 = each.value.sku
  sku_tier            = each.value.sku_tier

  frontend_ip_configurations = {
    for f_k, f_v in each.value.frontend_ip_configurations :
    f_k => {
      name                          = f_v.name
      public_ip_address_id          = f_v.public_ip_key != null ? module.public_ip[f_v.public_ip_key].id : f_v.public_ip_address_id
      subnet_id                     = f_v.vnet_key != null && f_v.subnet_key != null ? module.virtual_network[f_v.vnet_key].subnet_ids[f_v.subnet_key] : f_v.subnet_id
      private_ip_address            = f_v.private_ip_address
      private_ip_address_allocation = f_v.private_ip_address_allocation
      private_ip_address_version    = f_v.private_ip_address_version
      zones                         = f_v.zones
    }
  }

  backend_address_pools = each.value.backend_address_pools
  probes                = each.value.probes
  load_balancing_rules  = each.value.load_balancing_rules
  inbound_nat_rules     = each.value.inbound_nat_rules
  tags                  = merge(local.environment_tags, try(each.value.tags, {}))
}

module "user_assigned_identity" {
  for_each = var.user_assigned_identities
  source   = "../../modules/user_assigned_identity"

  name                           = each.value.name
  resource_group_name            = module.resource_group[each.value.resource_group_key].name
  location                       = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  federated_identity_credentials = each.value.federated_identity_credentials
  tags                           = merge(local.environment_tags, try(each.value.tags, {}))
}

module "role_definition" {
  for_each = var.role_definitions
  source   = "../../modules/role_definition"

  name               = each.value.name
  scope              = coalesce(each.value.scope, data.azurerm_subscription.current.id)
  role_definition_id = each.value.role_definition_id
  description        = each.value.description
  permissions        = each.value.permissions
  assignable_scopes  = each.value.assignable_scopes
}

module "role_assignment" {
  for_each = var.role_assignments
  source   = "../../modules/role_assignment"

  name = each.value.name
  scope = (
    each.value.scope != null ? each.value.scope :
    each.value.scope_resource_type == "resource_group" ? module.resource_group[each.value.scope_resource_key].id :
    each.value.scope_resource_type == "key_vault" ? module.key_vault[each.value.scope_resource_key].id :
    each.value.scope_resource_type == "container_registry" ? module.container_registry[each.value.scope_resource_key].id :
    each.value.scope_resource_type == "storage_account" ? module.storage_account[each.value.scope_resource_key].id :
    each.value.scope_resource_type == "aks" ? module.aks[each.value.scope_resource_key].id :
    data.azurerm_subscription.current.id
  )
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_key != null ? module.role_definition[each.value.role_definition_key].role_definition_resource_id : each.value.role_definition_id
  principal_id                     = each.value.identity_key != null ? module.user_assigned_identity[each.value.identity_key].principal_id : each.value.principal_id
  principal_type                   = each.value.principal_type
  description                      = each.value.description
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
  condition                        = each.value.condition
  condition_version                = each.value.condition_version
}

module "federated_identity_credential" {
  for_each = var.federated_identity_credentials
  source   = "../../modules/federated_identity_credential"

  name                = each.value.name
  resource_group_name = each.value.resource_group_key != null ? module.resource_group[each.value.resource_group_key].name : each.value.resource_group_name
  parent_id           = each.value.identity_key != null ? module.user_assigned_identity[each.value.identity_key].id : each.value.parent_id
  audience            = each.value.audience
  issuer              = each.value.issuer
  subject             = each.value.subject
}

module "marketplace_role_assignment" {
  for_each = var.marketplace_role_assignments
  source   = "../../modules/marketplace_role_assignment"

  principal_id                           = each.value.identity_key != null ? module.user_assigned_identity[each.value.identity_key].principal_id : each.value.principal_id
  role_definition_name                   = each.value.role_definition_name
  role_definition_id                     = each.value.role_definition_id
  name                                   = each.value.name
  description                            = each.value.description
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

module "pim_active_role_assignment" {
  for_each = var.pim_active_role_assignments
  source   = "../../modules/pim_active_role_assignment"

  scope = (
    each.value.scope != null ? each.value.scope :
    each.value.scope_resource_type == "resource_group" ? module.resource_group[each.value.scope_resource_key].id :
    data.azurerm_subscription.current.id
  )
  role_definition_id = each.value.role_definition_key != null ? module.role_definition[each.value.role_definition_key].role_definition_resource_id : each.value.role_definition_id
  principal_id       = each.value.identity_key != null ? module.user_assigned_identity[each.value.identity_key].principal_id : each.value.principal_id
  justification      = each.value.justification
  schedule           = each.value.schedule
  ticket             = each.value.ticket
}

module "pim_eligible_role_assignment" {
  for_each = var.pim_eligible_role_assignments
  source   = "../../modules/pim_eligible_role_assignment"

  scope = (
    each.value.scope != null ? each.value.scope :
    each.value.scope_resource_type == "resource_group" ? module.resource_group[each.value.scope_resource_key].id :
    data.azurerm_subscription.current.id
  )
  role_definition_id = each.value.role_definition_key != null ? module.role_definition[each.value.role_definition_key].role_definition_resource_id : each.value.role_definition_id
  principal_id       = each.value.identity_key != null ? module.user_assigned_identity[each.value.identity_key].principal_id : each.value.principal_id
  justification      = each.value.justification
  condition          = each.value.condition
  condition_version  = each.value.condition_version
  schedule           = each.value.schedule
  ticket             = each.value.ticket
}

module "role_management_policy" {
  for_each = var.role_management_policies
  source   = "../../modules/role_management_policy"

  scope = (
    each.value.scope != null ? each.value.scope :
    each.value.scope_resource_type == "resource_group" ? module.resource_group[each.value.scope_resource_key].id :
    data.azurerm_subscription.current.id
  )
  role_definition_id        = each.value.role_definition_key != null ? module.role_definition[each.value.role_definition_key].role_definition_resource_id : each.value.role_definition_id
  activation_rules          = each.value.activation_rules
  active_assignment_rules   = each.value.active_assignment_rules
  eligible_assignment_rules = each.value.eligible_assignment_rules
  notification_rules        = each.value.notification_rules
}

module "route_table" {
  for_each = var.route_tables
  source   = "../../modules/route_table"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  routes                        = each.value.routes
  subnet_ids = {
    for s_k, s_v in each.value.subnet_associations :
    s_k => module.virtual_network[s_v.vnet_key].subnet_ids[s_v.subnet_key]
  }
  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "log_analytics_workspace" {
  for_each = var.log_analytics_workspaces
  source   = "../../modules/log_analytics_workspace"

  name                               = each.value.name
  resource_group_name                = module.resource_group[each.value.resource_group_key].name
  location                           = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  sku                                = each.value.sku
  retention_in_days                  = each.value.retention_in_days
  daily_quota_gb                     = each.value.daily_quota_gb
  internet_ingestion_enabled         = each.value.internet_ingestion_enabled
  internet_query_enabled             = each.value.internet_query_enabled
  reservation_capacity_in_gb_per_day = each.value.reservation_capacity_in_gb_per_day
  data_collection_rule_id            = each.value.data_collection_rule_id
  tags                               = merge(local.environment_tags, try(each.value.tags, {}))
}

module "monitor_diagnostic_setting" {
  for_each = var.monitor_diagnostic_settings
  source   = "../../modules/monitor_diagnostic_setting"

  name = each.value.name
  target_resource_id = (
    each.value.target_resource_id != null ? each.value.target_resource_id :
    each.value.target_resource_type == "key_vault" ? module.key_vault[each.value.target_resource_key].id :
    each.value.target_resource_type == "container_registry" ? module.container_registry[each.value.target_resource_key].id :
    each.value.target_resource_type == "aks" ? module.aks[each.value.target_resource_key].id :
    each.value.target_resource_type == "application_gateway" ? module.application_gateway[each.value.target_resource_key].id :
    each.value.target_resource_type == "load_balancer" ? module.load_balancer[each.value.target_resource_key].id :
    null
  )
  log_analytics_workspace_id     = each.value.log_analytics_workspace_key != null ? module.log_analytics_workspace[each.value.log_analytics_workspace_key].id : each.value.log_analytics_workspace_id
  storage_account_id             = each.value.storage_account_key != null ? module.storage_account[each.value.storage_account_key].id : each.value.storage_account_id
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  eventhub_name                  = each.value.eventhub_name
  partner_solution_id            = each.value.partner_solution_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  enabled_log_category_groups    = each.value.enabled_log_category_groups
  enabled_log_categories         = each.value.enabled_log_categories
  metric_categories              = each.value.metric_categories
}

module "nat_gateway" {
  for_each = var.nat_gateways
  source   = "../../modules/nat_gateway"

  name                    = each.value.name
  resource_group_name     = module.resource_group[each.value.resource_group_key].name
  location                = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  zones                   = each.value.zones
  public_ip_address_ids = concat(
    [for pip_key in each.value.public_ip_keys : module.public_ip[pip_key].id],
    each.value.public_ip_address_ids
  )
  public_ip_prefix_ids = each.value.public_ip_prefix_ids
  subnet_ids = {
    for s_k, s_v in each.value.subnet_associations :
    s_k => module.virtual_network[s_v.vnet_key].subnet_ids[s_v.subnet_key]
  }
  tags = merge(local.environment_tags, try(each.value.tags, {}))
}

module "management_group" {
  for_each = var.management_groups
  source   = "../../modules/management_group"

  name                       = each.value.name
  display_name               = each.value.display_name
  parent_management_group_id = each.value.parent_management_group_id
  subscription_ids           = each.value.subscription_ids
}

module "policy_definition" {
  for_each = var.policy_definitions
  source   = "../../modules/policy_definition"

  name                = each.value.name
  policy_type         = each.value.policy_type
  mode                = each.value.mode
  display_name        = each.value.display_name
  description         = each.value.description
  management_group_id = each.value.management_group_id
  policy_rule         = each.value.policy_rule
  metadata            = each.value.metadata
  parameters          = each.value.parameters
}

module "policy_assignment" {
  for_each = var.policy_assignments
  source   = "../../modules/policy_assignment"

  name                    = each.value.name
  scope_type              = each.value.scope_type
  subscription_id         = coalesce(each.value.subscription_id, data.azurerm_subscription.current.id)
  resource_group_id       = each.value.resource_group_key != null ? module.resource_group[each.value.resource_group_key].id : each.value.resource_group_id
  policy_definition_id    = each.value.policy_definition_id
  display_name            = each.value.display_name
  description             = each.value.description
  enforce                 = each.value.enforce
  parameters              = each.value.parameters
  location                = each.value.location
  identity_type           = each.value.identity_type
  identity_ids            = each.value.identity_ids
  non_compliance_messages = each.value.non_compliance_messages
}

module "consumption_budget" {
  for_each = var.consumption_budgets
  source   = "../../modules/consumption_budget"

  name              = each.value.name
  scope_type        = each.value.scope_type
  subscription_id   = coalesce(each.value.subscription_id, data.azurerm_subscription.current.id)
  resource_group_id = each.value.resource_group_key != null ? module.resource_group[each.value.resource_group_key].id : each.value.resource_group_id
  amount            = each.value.amount
  time_grain        = each.value.time_grain
  time_period       = each.value.time_period
  notifications     = each.value.notifications
}

module "recovery_services_vault" {
  for_each = var.recovery_services_vaults
  source   = "../../modules/recovery_services_vault"

  name                         = each.value.name
  resource_group_name          = module.resource_group[each.value.resource_group_key].name
  location                     = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  sku                          = each.value.sku
  storage_mode_type            = each.value.storage_mode_type
  cross_region_restore_enabled = each.value.cross_region_restore_enabled
  soft_delete_enabled          = each.value.soft_delete_enabled
  vm_backup_policies           = each.value.vm_backup_policies
  tags                         = merge(local.environment_tags, try(each.value.tags, {}))
}

module "mssql_server" {
  for_each = var.mssql_servers
  source   = "../../modules/mssql_server"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  server_version                = each.value.server_version
  administrator_login           = each.value.administrator_login
  administrator_login_password  = each.value.administrator_login_password
  minimum_tls_version           = each.value.minimum_tls_version
  public_network_access_enabled = each.value.public_network_access_enabled
  azuread_administrator         = each.value.azuread_administrator
  databases                     = each.value.databases
  firewall_rules                = each.value.firewall_rules
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "servicebus_namespace" {
  for_each = var.servicebus_namespaces
  source   = "../../modules/servicebus_namespace"

  name                          = each.value.name
  resource_group_name           = module.resource_group[each.value.resource_group_key].name
  location                      = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  sku                           = each.value.sku
  capacity                      = each.value.capacity
  minimum_tls_version           = each.value.minimum_tls_version
  public_network_access_enabled = each.value.public_network_access_enabled
  queues                        = each.value.queues
  topics                        = each.value.topics
  tags                          = merge(local.environment_tags, try(each.value.tags, {}))
}

module "key_vault_secret" {
  for_each = var.key_vault_secrets
  source   = "../../modules/key_vault_secret"

  key_vault_id = each.value.key_vault_key != null ? module.key_vault[each.value.key_vault_key].id : each.value.key_vault_id
  secrets      = each.value.secrets
  tags         = merge(local.environment_tags, try(each.value.tags, {}))
}

module "monitor_action_group" {
  for_each = var.monitor_action_groups
  source   = "../../modules/monitor_action_group"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  short_name          = each.value.short_name
  enabled             = each.value.enabled
  location            = each.value.location
  email_receivers     = each.value.email_receivers
  sms_receivers       = each.value.sms_receivers
  webhook_receivers   = each.value.webhook_receivers
  tags                = merge(local.environment_tags, try(each.value.tags, {}))
}

module "monitor_metric_alert" {
  for_each = var.monitor_metric_alerts
  source   = "../../modules/monitor_metric_alert"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  scopes = [
    for scope in each.value.scopes :
    scope.type == "vm" ? module.virtual_machine[scope.key].id :
    scope.type == "storage" ? module.storage_account[scope.key].id :
    scope.id
  ]
  description      = each.value.description
  severity         = each.value.severity
  frequency        = each.value.frequency
  window_size      = each.value.window_size
  criteria         = each.value.criteria
  action_group_ids = [for ag_key in each.value.action_group_keys : module.monitor_action_group[ag_key].id]
  tags             = merge(local.environment_tags, try(each.value.tags, {}))
}

module "event_grid_topic" {
  for_each = var.event_grid_topics
  source   = "../../modules/event_grid_topic"

  name                = each.value.name
  resource_group_name = module.resource_group[each.value.resource_group_key].name
  location            = coalesce(each.value.location, module.resource_group[each.value.resource_group_key].location)
  input_schema        = each.value.input_schema
  tags                = merge(local.environment_tags, try(each.value.tags, {}))
}
