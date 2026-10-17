variable "environment" {
  description = "The target deployment environment (e.g., dev, qa, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project or application workload."
  type        = string
  default     = "core"
}

variable "location" {
  description = "The primary Azure region for resources."
  type        = string
  default     = "eastus2"
}

variable "common_tags" {
  description = "Common baseline tags to be merged and applied to all resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "DevOps"
  }
}

variable "resource_groups" {
  description = "Map of resource groups to provision using the resource_group child module."
  type = map(object({
    name       = string
    location   = string
    lock_level = optional(string, null)
    lock_notes = optional(string, "Managed by Terraform")
    tags       = optional(map(string), {})
  }))
}

variable "virtual_networks" {
  description = "Map of virtual networks to provision using the virtual_network child module."
  type = map(object({
    name                 = string
    resource_group_key   = string
    address_space        = list(string)
    dns_servers          = optional(list(string), [])
    ddos_protection_plan = optional(object({ id = string, enable = bool }), null)
    subnets = optional(map(object({
      name                                          = optional(string)
      address_prefixes                              = list(string)
      service_endpoints                             = optional(list(string), [])
      service_endpoint_policy_ids                   = optional(list(string), [])
      private_endpoint_network_policies             = optional(string, "Disabled")
      private_link_service_network_policies_enabled = optional(bool, true)
      network_security_group_id                     = optional(string, null)
      route_table_id                                = optional(string, null)
      delegations = optional(list(object({
        name = string
        service_delegation = object({
          name    = string
          actions = optional(list(string), [])
        })
      })), [])
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "network_security_groups" {
  description = "Map of network security groups to provision using the network_security_group child module."
  type = map(object({
    name               = string
    resource_group_key = string
    security_rules = optional(map(object({
      name                                       = optional(string)
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      description                                = optional(string)
    })), {})
    subnet_associations = optional(map(object({
      vnet_key   = string
      subnet_key = string
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Map of storage accounts to provision using the storage_account child module."
  type = map(object({
    name                            = string
    resource_group_key              = string
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    account_kind                    = optional(string, "StorageV2")
    min_tls_version                 = optional(string, "TLS1_2")
    public_network_access_enabled   = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    shared_access_key_enabled       = optional(bool, true)
    is_hns_enabled                  = optional(bool, false)
    blob_versioning_enabled         = optional(bool, false)
    blob_delete_retention_days      = optional(number, 7)
    container_delete_retention_days = optional(number, 7)
    network_rules = optional(object({
      default_action             = string
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
      subnet_references = optional(list(object({
        vnet_key   = string
        subnet_key = string
      })), [])
      bypass = optional(list(string), ["AzureServices"])
    }), null)
    containers = optional(map(object({
      name                  = optional(string)
      container_access_type = optional(string, "private")
      metadata              = optional(map(string), {})
    })), {})
    file_shares = optional(map(object({
      name  = optional(string)
      quota = optional(number, 50)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "key_vaults" {
  description = "Map of key vaults to provision using the key_vault child module."
  type = map(object({
    name                            = string
    resource_group_key              = string
    sku_name                        = optional(string, "standard")
    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enable_rbac_authorization       = optional(bool, true)
    purge_protection_enabled        = optional(bool, false)
    soft_delete_retention_days      = optional(number, 7)
    public_network_access_enabled   = optional(bool, true)
    network_acls = optional(object({
      bypass                     = optional(string, "AzureServices")
      default_action             = string
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
      subnet_references = optional(list(object({
        vnet_key   = string
        subnet_key = string
      })), [])
    }), null)
    access_policies = optional(map(object({
      object_id               = string
      tenant_id               = optional(string)
      application_id          = optional(string)
      certificate_permissions = optional(list(string), [])
      key_permissions         = optional(list(string), [])
      secret_permissions      = optional(list(string), [])
      storage_permissions     = optional(list(string), [])
    })), {})
    role_assignments = optional(map(object({
      role_definition_name = optional(string)
      role_definition_id   = optional(string)
      principal_id         = string
      description          = optional(string)
    })), {})
    secrets = optional(map(object({
      name            = optional(string)
      value           = string
      content_type    = optional(string)
      not_before_date = optional(string)
      expiration_date = optional(string)
      tags            = optional(map(string), {})
    })), {})
    keys = optional(map(object({
      name     = optional(string)
      key_type = optional(string, "RSA")
      key_size = optional(number, 2048)
      key_opts = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])
      tags     = optional(map(string), {})
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "private_endpoints" {
  description = "Map of private endpoints to provision using the private_endpoint child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    vnet_key                      = string
    subnet_key                    = string
    target_type                   = string
    target_key                    = optional(string)
    custom_target_resource_id     = optional(string)
    subresource_names             = list(string)
    is_manual_connection          = optional(bool, false)
    request_message               = optional(string, null)
    custom_network_interface_name = optional(string, null)
    private_dns_zone_group = optional(object({
      name                 = optional(string, "default")
      private_dns_zone_ids = list(string)
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "aks_clusters" {
  description = "Map of Azure Kubernetes Service clusters to provision using the aks child module."
  type = map(object({
    name                               = string
    resource_group_key                 = string
    dns_prefix                         = optional(string)
    kubernetes_version                 = optional(string)
    sku_tier                           = optional(string, "Free")
    private_cluster_enabled            = optional(bool, false)
    workload_identity_enabled          = optional(bool, true)
    oidc_issuer_enabled                = optional(bool, true)
    node_resource_group                = optional(string)
    identity_type                      = optional(string, "SystemAssigned")
    user_assigned_identity_id          = optional(string)
    key_vault_secrets_provider_enabled = optional(bool, false)
    secret_rotation_enabled            = optional(bool, false)
    default_node_pool = object({
      name                         = optional(string, "system")
      vm_size                      = optional(string, "Standard_D2s_v5")
      node_count                   = optional(number, 1)
      enable_auto_scaling          = optional(bool, false)
      min_count                    = optional(number, null)
      max_count                    = optional(number, null)
      os_disk_size_gb              = optional(number, 30)
      os_disk_type                 = optional(string, "Managed")
      vnet_key                     = optional(string)
      subnet_key                   = optional(string)
      zones                        = optional(list(string), [])
      node_labels                  = optional(map(string), {})
      node_taints                  = optional(list(string), [])
      only_critical_addons_enabled = optional(bool, false)
      temporary_name_for_rotation  = optional(string, "systemtmp")
      tags                         = optional(map(string), {})
    })
    network_profile = optional(object({
      network_plugin      = optional(string, "azure")
      network_plugin_mode = optional(string, null)
      network_policy      = optional(string, "azure")
      dns_service_ip      = optional(string, "172.16.0.10")
      service_cidr        = optional(string, "172.16.0.0/16")
      pod_cidr            = optional(string, null)
      load_balancer_sku   = optional(string, "standard")
      outbound_type       = optional(string, "loadBalancer")
    }), null)
    node_pools = optional(map(object({
      name                = optional(string)
      vm_size             = optional(string, "Standard_D2s_v5")
      enable_auto_scaling = optional(bool, false)
      node_count          = optional(number, 1)
      min_count           = optional(number, null)
      max_count           = optional(number, null)
      os_disk_size_gb     = optional(number, 30)
      os_disk_type        = optional(string, "Managed")
      vnet_key            = optional(string)
      subnet_key          = optional(string)
      mode                = optional(string, "User")
      zones               = optional(list(string), [])
      node_labels         = optional(map(string), {})
      node_taints         = optional(list(string), [])
      tags                = optional(map(string), {})
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "container_registries" {
  description = "Map of container registries to provision using the container_registry child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    sku                           = optional(string, "Standard")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    zone_redundancy_enabled       = optional(bool, false)
    export_policy_enabled         = optional(bool, true)
    network_rule_set = optional(object({
      default_action = optional(string, "Allow")
      ip_rules       = optional(list(string), [])
    }), null)
    georeplications = optional(list(object({
      location                = string
      zone_redundancy_enabled = optional(bool, false)
      tags                    = optional(map(string), {})
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "virtual_machines" {
  description = "Map of virtual machines to provision using the virtual_machine child module."
  type = map(object({
    name                            = string
    resource_group_key              = string
    os_type                         = optional(string, "Linux")
    size                            = optional(string, "Standard_D2s_v6")
    admin_username                  = optional(string, "azureuser")
    admin_password                  = optional(string, null)
    admin_ssh_key                   = optional(string, null)
    disable_password_authentication = optional(bool, true)
    vnet_key                        = string
    subnet_key                      = string
    private_ip_address_allocation   = optional(string, "Dynamic")
    private_ip_address              = optional(string, null)
    public_ip_key                   = optional(string, null)
    public_ip_id                    = optional(string, null)
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_LRS")
      disk_size_gb         = optional(number, 30)
      }), {
      caching              = "ReadWrite"
      storage_account_type = "StandardSSD_LRS"
      disk_size_gb         = 30
    })
    source_image_reference = optional(object({
      publisher = optional(string, "Canonical")
      offer     = optional(string, "0001-com-ubuntu-server-jammy")
      sku       = optional(string, "22_04-lts-gen2")
      version   = optional(string, "latest")
      }), {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    })
    data_disks = optional(map(object({
      name                 = optional(string)
      disk_size_gb         = number
      lun                  = number
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_LRS")
    })), {})
    custom_data                = optional(string, null)
    identity_type              = optional(string, "SystemAssigned")
    user_assigned_identity_ids = optional(list(string), [])
    tags                       = optional(map(string), {})
  }))
  default = {}
}

variable "application_gateways" {
  description = "Map of Application Gateways to provision using the application_gateway child module."
  type = map(object({
    name               = string
    resource_group_key = string
    vnet_key           = string
    subnet_key         = string
    sku = optional(object({
      name     = optional(string, "Standard_v2")
      tier     = optional(string, "Standard_v2")
      capacity = optional(number, null)
      }), {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = null
    })
    autoscale_configuration = optional(object({
      min_capacity = number
      max_capacity = optional(number, 3)
      }), {
      min_capacity = 1
      max_capacity = 2
    })
    zones                          = optional(list(string), [])
    public_ip_key                  = optional(string, null)
    public_ip_id                   = optional(string, null)
    gateway_ip_configuration_name  = optional(string, "appGatewayIpConfig")
    frontend_ip_configuration_name = optional(string, "appGwPublicFrontendIp")
    frontend_ports = optional(map(object({
      port = number
      name = optional(string)
      })), {
      http = {
        port = 80
        name = "port_80"
      }
    })
    backend_address_pools = optional(map(object({
      name         = optional(string)
      fqdns        = optional(list(string), [])
      ip_addresses = optional(list(string), [])
      })), {
      default = {
        name         = "default-backend-pool"
        fqdns        = []
        ip_addresses = []
      }
    })
    backend_http_settings = optional(map(object({
      name                                = optional(string)
      cookie_based_affinity               = optional(string, "Disabled")
      affinity_cookie_name                = optional(string, null)
      port                                = optional(number, 80)
      protocol                            = optional(string, "Http")
      request_timeout                     = optional(number, 30)
      probe_name                          = optional(string, null)
      path                                = optional(string, null)
      host_name                           = optional(string, null)
      pick_host_name_from_backend_address = optional(bool, false)
      })), {
      default = {
        name                                = "default-http-settings"
        cookie_based_affinity               = "Disabled"
        port                                = 80
        protocol                            = "Http"
        request_timeout                     = 30
        pick_host_name_from_backend_address = false
      }
    })
    http_listeners = optional(map(object({
      name                           = optional(string)
      frontend_ip_configuration_name = optional(string, null)
      frontend_port_name             = optional(string, null)
      protocol                       = optional(string, "Http")
      ssl_certificate_name           = optional(string, null)
      host_name                      = optional(string, null)
      host_names                     = optional(list(string), [])
      require_sni                    = optional(bool, false)
      })), {
      http = {
        name       = "http-listener"
        protocol   = "Http"
        host_name  = null
        host_names = []
      }
    })
    request_routing_rules = optional(map(object({
      name                        = optional(string)
      rule_type                   = optional(string, "Basic")
      http_listener_key           = optional(string, "http")
      http_listener_name          = optional(string, null)
      backend_address_pool_key    = optional(string, "default")
      backend_address_pool_name   = optional(string, null)
      backend_http_settings_key   = optional(string, "default")
      backend_http_settings_name  = optional(string, null)
      url_path_map_name           = optional(string, null)
      redirect_configuration_name = optional(string, null)
      priority                    = number
      })), {
      default = {
        name                      = "default-routing-rule"
        rule_type                 = "Basic"
        http_listener_key         = "http"
        backend_address_pool_key  = "default"
        backend_http_settings_key = "default"
        priority                  = 100
      }
    })
    probes = optional(map(object({
      name                                      = optional(string)
      protocol                                  = optional(string, "Http")
      path                                      = optional(string, "/")
      host                                      = optional(string, null)
      interval                                  = optional(number, 30)
      timeout                                   = optional(number, 30)
      unhealthy_threshold                       = optional(number, 3)
      pick_host_name_from_backend_http_settings = optional(bool, false)
      match = optional(object({
        body        = optional(string, null)
        status_code = list(string)
      }), null)
    })), {})
    ssl_certificates = optional(map(object({
      name                = optional(string)
      data                = optional(string, null)
      password            = optional(string, null)
      key_vault_secret_id = optional(string, null)
    })), {})
    waf_configuration = optional(object({
      enabled          = bool
      firewall_mode    = optional(string, "Prevention")
      rule_set_type    = optional(string, "OWASP")
      rule_set_version = optional(string, "3.2")
    }), null)
    identity_type              = optional(string, null)
    user_assigned_identity_ids = optional(list(string), [])
    tags                       = optional(map(string), {})
  }))
  default = {}
}

variable "azure_firewalls" {
  description = "Map of Azure Firewalls to provision using the azure_firewall child module."
  type = map(object({
    name                     = string
    resource_group_key       = string
    vnet_key                 = string
    subnet_key               = string
    management_subnet_key    = optional(string, null)
    sku_name                 = optional(string, "AZFW_VNet")
    sku_tier                 = optional(string, "Standard")
    zones                    = optional(list(string), [])
    public_ip_key            = optional(string, null)
    public_ip_id             = optional(string, null)
    management_public_ip_key = optional(string, null)
    management_public_ip_id  = optional(string, null)
    threat_intel_mode        = optional(string, "Alert")
    dns_proxy_enabled        = optional(bool, false)
    dns_servers              = optional(list(string), [])
    create_firewall_policy   = optional(bool, true)
    firewall_policy_id       = optional(string, null)
    network_rule_collections = optional(map(object({
      priority = number
      action   = string
      rules = map(object({
        protocols             = list(string)
        destination_ports     = list(string)
        source_addresses      = optional(list(string), [])
        destination_addresses = optional(list(string), [])
        destination_fqdns     = optional(list(string), [])
      }))
    })), {})
    application_rule_collections = optional(map(object({
      priority = number
      action   = string
      rules = map(object({
        source_addresses  = optional(list(string), [])
        destination_fqdns = optional(list(string), [])
        protocols = optional(list(object({
          port = number
          type = string
          })), [
          {
            port = 443
            type = "Https"
          },
          {
            port = 80
            type = "Http"
          }
        ])
      }))
    })), {})
    nat_rule_collections = optional(map(object({
      priority = number
      action   = string
      rules = map(object({
        protocols           = list(string)
        source_addresses    = list(string)
        destination_address = optional(string, null)
        destination_ports   = list(string)
        translated_address  = string
        translated_port     = number
      }))
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "private_dns_zones" {
  description = "Map of Private DNS Zones to provision using the private_dns_zone child module."
  type = map(object({
    name               = string
    resource_group_key = string
    virtual_network_links = optional(map(object({
      name                 = optional(string)
      vnet_key             = string
      registration_enabled = optional(bool, false)
      tags                 = optional(map(string), {})
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "postgresql_flexible_servers" {
  description = "Map of PostgreSQL Flexible Servers to provision using the postgresql_flexible_server child module."
  type = map(object({
    name                              = string
    resource_group_key                = string
    server_version                    = optional(string, "16")
    sku_name                          = optional(string, "B_Standard_B1ms")
    storage_mb                        = optional(number, 32768)
    storage_tier                      = optional(string, null)
    auto_grow_enabled                 = optional(bool, true)
    backup_retention_days             = optional(number, 7)
    geo_redundant_backup_enabled      = optional(bool, false)
    create_mode                       = optional(string, "Default")
    source_server_id                  = optional(string, null)
    point_in_time_restore_time_in_utc = optional(string, null)
    zone                              = optional(string, null)
    administrator_login               = optional(string, "psqladmin")
    administrator_password            = optional(string, null)
    admin_password_length             = optional(number, 24)
    vnet_key                          = optional(string, null)
    subnet_key                        = optional(string, null)
    private_dns_zone_key              = optional(string, null)
    private_dns_zone_id               = optional(string, null)
    public_network_access_enabled     = optional(bool, false)
    high_availability = optional(object({
      mode                      = string
      standby_availability_zone = optional(string, null)
    }), null)
    maintenance_window = optional(object({
      day_of_week  = optional(number, 0)
      start_hour   = optional(number, 0)
      start_minute = optional(number, 0)
    }), null)
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
      tenant_id                     = optional(string, null)
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }), null)
    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      primary_user_assigned_identity_id = string
    }), null)
    databases = optional(map(object({
      name      = optional(string)
      charset   = optional(string, "UTF8")
      collation = optional(string, "en_US.utf8")
    })), {})
    firewall_rules = optional(map(object({
      name             = optional(string)
      start_ip_address = string
      end_ip_address   = string
    })), {})
    server_configurations = optional(map(string), {})
    ad_admin = optional(object({
      object_id      = string
      principal_name = string
      principal_type = string
      tenant_id      = string
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "bastion_hosts" {
  description = "Map of Bastion Hosts to provision using the bastion_host child module."
  type = map(object({
    name                      = string
    resource_group_key        = string
    vnet_key                  = string
    subnet_key                = string
    public_ip_key             = optional(string, null)
    public_ip_id              = optional(string, null)
    ip_configuration_name     = optional(string, null)
    sku                       = optional(string, "Standard")
    scale_units               = optional(number, 2)
    copy_paste_enabled        = optional(bool, true)
    file_copy_enabled         = optional(bool, true)
    ip_connect_enabled        = optional(bool, true)
    shareable_link_enabled    = optional(bool, false)
    tunneling_enabled         = optional(bool, true)
    session_recording_enabled = optional(bool, false)
    kerberos_enabled          = optional(bool, false)
    zones                     = optional(list(string), [])
    tags                      = optional(map(string), {})
  }))
  default = {}
}

variable "function_apps" {
  description = "Map of Function Apps to provision using the function_app child module."
  type = map(object({
    name                                   = string
    resource_group_key                     = string
    storage_account_key                    = string
    service_plan_id                        = optional(string, null)
    service_plan_name                      = optional(string, null)
    sku_name                               = optional(string, "Y1")
    functions_extension_version            = optional(string, "~4")
    https_only                             = optional(bool, true)
    public_network_access_enabled          = optional(bool, true)
    vnet_key                               = optional(string, null)
    subnet_key                             = optional(string, null)
    vnet_route_all_enabled                 = optional(bool, false)
    application_insights_connection_string = optional(string, null)
    application_insights_key               = optional(string, null)
    identity_type                          = optional(string, "SystemAssigned")
    user_assigned_identity_ids             = optional(list(string), [])
    application_stack = optional(object({
      dotnet_version              = optional(string)
      java_version                = optional(string)
      node_version                = optional(string)
      powershell_core_version     = optional(string)
      python_version              = optional(string, "3.11")
      use_custom_runtime          = optional(bool)
      use_dotnet_isolated_runtime = optional(bool)
      }), {
      python_version = "3.11"
    })
    app_settings = optional(map(string), {})
    functions = optional(map(object({
      name        = optional(string)
      config_json = string
      language    = optional(string, null)
      enabled     = optional(bool, true)
      test_data   = optional(string, null)
      files = optional(map(object({
        name    = optional(string)
        content = string
      })), {})
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "monitor_workspaces" {
  description = "Map of Azure Monitor Workspaces (Managed Prometheus) to provision using the monitor_workspace child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    public_network_access_enabled = optional(bool, true)
    prometheus_rule_groups = optional(map(object({
      name               = string
      resource_group_key = optional(string, null)
      location           = optional(string, null)
      description        = optional(string, null)
      rule_group_enabled = optional(bool, true)
      interval           = optional(string, "PT1M")
      cluster_name       = optional(string, null)
      scopes             = optional(list(string), [])
      rules = list(object({
        enabled     = optional(bool, true)
        expression  = string
        record      = optional(string, null)
        alert       = optional(string, null)
        severity    = optional(number, null)
        for         = optional(string, null)
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
        actions = optional(list(object({
          action_group_id   = string
          action_properties = optional(map(string), {})
        })), [])
      }))
      tags = optional(map(string), {})
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "virtual_network_peerings" {
  description = "Map of virtual network peerings to configure using the virtual_network_peering child module."
  type = map(object({
    name                         = optional(string)
    vnet_key                     = string
    resource_group_key           = optional(string)
    remote_vnet_key              = optional(string)
    remote_virtual_network_id    = optional(string)
    use_remote_vnet_data_source  = optional(bool, false)
    remote_virtual_network_name  = optional(string)
    remote_resource_group_name   = optional(string)
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
}

variable "public_ips" {
  description = "Map of standalone Public IP addresses to provision using the public_ip child module."
  type = map(object({
    name                    = string
    resource_group_key      = string
    allocation_method       = optional(string, "Static")
    sku                     = optional(string, "Standard")
    sku_tier                = optional(string, "Regional")
    zones                   = optional(list(string), [])
    ip_version              = optional(string, "IPv4")
    domain_name_label       = optional(string, null)
    reverse_fqdn            = optional(string, null)
    idle_timeout_in_minutes = optional(number, 4)
    public_ip_prefix_id     = optional(string, null)
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string, null)
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "service_plans" {
  description = "Map of App Service Plans (Server Farms) to provision using the service_plan child module."
  type = map(object({
    name                         = string
    resource_group_key           = string
    location                     = optional(string)
    os_type                      = optional(string, "Linux")
    sku_name                     = optional(string, "B1")
    worker_count                 = optional(number, null)
    maximum_elastic_worker_count = optional(number, null)
    zone_balancing_enabled       = optional(bool, false)
    per_site_scaling_enabled     = optional(bool, false)
    tags                         = optional(map(string), {})
  }))
  default = {}
}

variable "app_services" {
  description = "Map of Azure App Services (Web Apps) to provision using the app_service child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    location                      = optional(string)
    os_type                       = optional(string, "Linux")
    service_plan_key              = optional(string, null)
    service_plan_id               = optional(string, null)
    service_plan_name             = optional(string, null)
    sku_name                      = optional(string, "B1")
    worker_count                  = optional(number, null)
    zone_balancing_enabled        = optional(bool, false)
    https_only                    = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
    vnet_key                      = optional(string, null)
    subnet_key                    = optional(string, null)
    vnet_route_all_enabled        = optional(bool, true)
    identity_type                 = optional(string, "SystemAssigned")
    user_assigned_identity_ids    = optional(list(string), [])
    app_settings                  = optional(map(string), {})
    connection_strings = optional(map(object({
      type  = string
      value = string
    })), {})
    application_stack = optional(object({
      dotnet_version           = optional(string)
      java_version             = optional(string)
      node_version             = optional(string)
      php_version              = optional(string)
      python_version           = optional(string)
      ruby_version             = optional(string)
      docker_image_name        = optional(string)
      docker_registry_url      = optional(string)
      docker_registry_username = optional(string)
      docker_registry_password = optional(string)
      current_stack            = optional(string)
    }), {})
    site_config = optional(object({
      always_on                  = optional(bool, false)
      http2_enabled              = optional(bool, true)
      minimum_tls_version        = optional(string, "1.2")
      ftps_state                 = optional(string, "Disabled")
      health_check_path          = optional(string)
      health_check_eviction_time = optional(number)
      cors = optional(object({
        allowed_origins     = list(string)
        support_credentials = optional(bool, false)
      }))
    }), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "load_balancers" {
  description = "Map of Azure Load Balancers to provision using the load_balancer child module."
  type = map(object({
    name               = string
    resource_group_key = string
    location           = optional(string)
    sku                = optional(string, "Standard")
    sku_tier           = optional(string, "Regional")
    frontend_ip_configurations = map(object({
      name                          = optional(string)
      public_ip_key                 = optional(string, null)
      public_ip_address_id          = optional(string, null)
      vnet_key                      = optional(string, null)
      subnet_key                    = optional(string, null)
      private_ip_address            = optional(string, null)
      private_ip_address_allocation = optional(string, "Dynamic")
      private_ip_address_version    = optional(string, "IPv4")
      zones                         = optional(list(string), null)
    }))
    backend_address_pools = optional(map(object({
      name = optional(string)
    })), {})
    probes = optional(map(object({
      name                = optional(string)
      protocol            = optional(string, "Tcp")
      port                = number
      request_path        = optional(string, null)
      interval_in_seconds = optional(number, 15)
      number_of_probes    = optional(number, 2)
      probe_threshold     = optional(number, 1)
    })), {})
    load_balancing_rules = optional(map(object({
      name                           = optional(string)
      frontend_ip_configuration_name = string
      backend_address_pool_name      = optional(string, null)
      probe_name                     = optional(string, null)
      protocol                       = optional(string, "Tcp")
      frontend_port                  = number
      backend_port                   = number
      enable_floating_ip             = optional(bool, false)
      idle_timeout_in_minutes        = optional(number, 4)
      load_distribution              = optional(string, "Default")
      enable_tcp_reset               = optional(bool, false)
      disable_outbound_snat          = optional(bool, false)
    })), {})
    inbound_nat_rules = optional(map(object({
      name                           = optional(string)
      frontend_ip_configuration_name = string
      protocol                       = optional(string, "Tcp")
      frontend_port                  = number
      backend_port                   = number
      idle_timeout_in_minutes        = optional(number, 4)
      enable_floating_ip             = optional(bool, false)
      enable_tcp_reset               = optional(bool, false)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "user_assigned_identities" {
  description = "Map of User Assigned Managed Identities to provision using the user_assigned_identity child module."
  type = map(object({
    name               = string
    resource_group_key = string
    location           = optional(string)
    federated_identity_credentials = optional(map(object({
      name     = optional(string)
      audience = optional(list(string), ["api://AzureADTokenExchange"])
      issuer   = string
      subject  = string
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "role_definitions" {
  description = "Map of Custom Azure RBAC Role Definitions to create using the role_definition child module."
  type = map(object({
    name               = string
    role_definition_id = optional(string, null)
    description        = optional(string, null)
    scope              = optional(string, null)
    permissions = optional(list(object({
      actions          = optional(list(string), [])
      not_actions      = optional(list(string), [])
      data_actions     = optional(list(string), [])
      not_data_actions = optional(list(string), [])
    })), [])
    assignable_scopes = optional(list(string), null)
  }))
  default = {}
}

variable "role_assignments" {
  description = "Map of Azure RBAC Role Assignments to create using the role_assignment child module."
  type = map(object({
    name                             = optional(string, null)
    scope                            = optional(string, null)
    scope_resource_type              = optional(string, null)
    scope_resource_key               = optional(string, null)
    role_definition_name             = optional(string, null)
    role_definition_key              = optional(string, null)
    role_definition_id               = optional(string, null)
    principal_id                     = optional(string, null)
    identity_key                     = optional(string, null)
    principal_type                   = optional(string, null)
    description                      = optional(string, null)
    skip_service_principal_aad_check = optional(bool, false)
    condition                        = optional(string, null)
    condition_version                = optional(string, null)
  }))
  default = {}
}

variable "federated_identity_credentials" {
  description = "Map of Federated Identity Credentials to provision using the federated_identity_credential child module."
  type = map(object({
    name                = string
    resource_group_key  = optional(string)
    resource_group_name = optional(string)
    identity_key        = optional(string)
    parent_id           = optional(string)
    audience            = optional(list(string), ["api://AzureADTokenExchange"])
    issuer              = string
    subject             = string
  }))
  default = {}
}

variable "marketplace_role_assignments" {
  description = "Map of Marketplace Role Assignments to create using the marketplace_role_assignment child module."
  type = map(object({
    principal_id                           = optional(string)
    identity_key                           = optional(string)
    role_definition_name                   = optional(string)
    role_definition_id                     = optional(string)
    name                                   = optional(string)
    description                            = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    condition                              = optional(string)
    condition_version                      = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
  }))
  default = {}
}

variable "pim_active_role_assignments" {
  description = "Map of PIM Active Role Assignments to create using the pim_active_role_assignment child module."
  type = map(object({
    scope               = optional(string)
    scope_resource_type = optional(string)
    scope_resource_key  = optional(string)
    role_definition_id  = optional(string)
    role_definition_key = optional(string)
    principal_id        = optional(string)
    identity_key        = optional(string)
    justification       = optional(string)
    schedule = optional(object({
      start_date_time = optional(string)
      expiration = optional(object({
        duration_hours = optional(number)
        duration_days  = optional(number)
        end_date_time  = optional(string)
      }))
    }))
    ticket = optional(object({
      number = optional(string)
      system = optional(string)
    }))
  }))
  default = {}
}

variable "pim_eligible_role_assignments" {
  description = "Map of PIM Eligible Role Assignments to create using the pim_eligible_role_assignment child module."
  type = map(object({
    scope               = optional(string)
    scope_resource_type = optional(string)
    scope_resource_key  = optional(string)
    role_definition_id  = optional(string)
    role_definition_key = optional(string)
    principal_id        = optional(string)
    identity_key        = optional(string)
    justification       = optional(string)
    condition           = optional(string)
    condition_version   = optional(string)
    schedule = optional(object({
      start_date_time = optional(string)
      expiration = optional(object({
        duration_hours = optional(number)
        duration_days  = optional(number)
        end_date_time  = optional(string)
      }))
    }))
    ticket = optional(object({
      number = optional(string)
      system = optional(string)
    }))
  }))
  default = {}
}

variable "role_management_policies" {
  description = "Map of PIM Role Management Policies to create using the role_management_policy child module."
  type = map(object({
    scope               = optional(string)
    scope_resource_type = optional(string)
    scope_resource_key  = optional(string)
    role_definition_id  = optional(string)
    role_definition_key = optional(string)
    activation_rules = optional(object({
      maximum_duration                                   = optional(string)
      require_approval                                   = optional(bool)
      require_justification                              = optional(bool)
      require_multifactor_authentication                 = optional(bool)
      require_ticket_info                                = optional(bool)
      required_conditional_access_authentication_context = optional(string)
      approval_stage = optional(object({
        primary_approver = list(object({
          object_id = string
          type      = string
        }))
      }))
    }))
    active_assignment_rules = optional(object({
      expiration_required                = optional(bool)
      expire_after                       = optional(string)
      require_justification              = optional(bool)
      require_multifactor_authentication = optional(bool)
      require_ticket_info                = optional(bool)
    }))
    eligible_assignment_rules = optional(object({
      expiration_required = optional(bool)
      expire_after        = optional(string)
    }))
    notification_rules = optional(object({
      active_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
      }))
      eligible_activations = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
      }))
      eligible_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
      }))
    }))
  }))
  default = {}
}

variable "route_tables" {
  description = "Map of Route Tables to provision using the route_table child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    location                      = optional(string)
    bgp_route_propagation_enabled = optional(bool, true)
    routes = optional(map(object({
      name                   = optional(string)
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string, null)
    })), {})
    subnet_associations = optional(map(object({
      vnet_key   = string
      subnet_key = string
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "log_analytics_workspaces" {
  description = "Map of Log Analytics Workspaces to provision using the log_analytics_workspace child module."
  type = map(object({
    name                               = string
    resource_group_key                 = string
    location                           = optional(string)
    sku                                = optional(string, "PerGB2018")
    retention_in_days                  = optional(number, 30)
    daily_quota_gb                     = optional(number, null)
    internet_ingestion_enabled         = optional(bool, true)
    internet_query_enabled             = optional(bool, true)
    reservation_capacity_in_gb_per_day = optional(number, null)
    data_collection_rule_id            = optional(string, null)
    tags                               = optional(map(string), {})
  }))
  default = {}
}

variable "monitor_diagnostic_settings" {
  description = "Map of Diagnostic Settings to configure using the monitor_diagnostic_setting child module."
  type = map(object({
    name                           = string
    target_resource_id             = optional(string)
    target_resource_type           = optional(string)
    target_resource_key            = optional(string)
    log_analytics_workspace_key    = optional(string)
    log_analytics_workspace_id     = optional(string)
    storage_account_key            = optional(string)
    storage_account_id             = optional(string)
    eventhub_authorization_rule_id = optional(string)
    eventhub_name                  = optional(string)
    partner_solution_id            = optional(string)
    log_analytics_destination_type = optional(string)
    enabled_log_category_groups    = optional(list(string), ["allLogs"])
    enabled_log_categories         = optional(list(string), [])
    metric_categories              = optional(list(string), ["AllMetrics"])
  }))
  default = {}
}

variable "nat_gateways" {
  description = "Map of NAT Gateways to provision using the nat_gateway child module."
  type = map(object({
    name                    = string
    resource_group_key      = string
    location                = optional(string)
    sku_name                = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number, 4)
    zones                   = optional(list(string))
    public_ip_keys          = optional(list(string), [])
    public_ip_address_ids   = optional(list(string), [])
    public_ip_prefix_ids    = optional(list(string), [])
    subnet_associations = optional(map(object({
      vnet_key   = string
      subnet_key = string
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "management_groups" {
  description = "Map of Management Groups to provision using the management_group child module."
  type = map(object({
    name                       = optional(string)
    display_name               = optional(string)
    parent_management_group_id = optional(string)
    subscription_ids           = optional(list(string), [])
  }))
  default = {}
}

variable "policy_definitions" {
  description = "Map of Policy Definitions to provision using the policy_definition child module."
  type = map(object({
    name                = string
    policy_type         = optional(string, "Custom")
    mode                = optional(string, "Indexed")
    display_name        = string
    description         = optional(string)
    management_group_id = optional(string)
    policy_rule         = string
    metadata            = optional(string)
    parameters          = optional(string)
  }))
  default = {}
}

variable "policy_assignments" {
  description = "Map of Policy Assignments to configure using the policy_assignment child module."
  type = map(object({
    name                 = string
    scope_type           = optional(string, "subscription")
    subscription_id      = optional(string)
    resource_group_key   = optional(string)
    resource_group_id    = optional(string)
    policy_definition_id = string
    display_name         = optional(string)
    description          = optional(string)
    enforce              = optional(bool, true)
    parameters           = optional(string)
    location             = optional(string)
    identity_type        = optional(string)
    identity_ids         = optional(list(string))
    non_compliance_messages = optional(list(object({
      content                        = string
      policy_definition_reference_id = optional(string, null)
    })), [])
  }))
  default = {}
}

variable "consumption_budgets" {
  description = "Map of Consumption Budgets to configure using the consumption_budget child module."
  type = map(object({
    name               = string
    scope_type         = optional(string, "subscription")
    subscription_id    = optional(string)
    resource_group_key = optional(string)
    resource_group_id  = optional(string)
    amount             = number
    time_grain         = optional(string, "Monthly")
    time_period = object({
      start_date = string
      end_date   = optional(string)
    })
    notifications = optional(map(object({
      operator       = string
      threshold      = number
      threshold_type = optional(string, "Actual")
      contact_emails = optional(list(string), [])
      contact_roles  = optional(list(string), ["Owner", "Contributor"])
      contact_groups = optional(list(string), [])
    })), {})
  }))
  default = {}
}

variable "recovery_services_vaults" {
  description = "Map of Recovery Services Vaults to provision using the recovery_services_vault child module."
  type = map(object({
    name                         = string
    resource_group_key           = string
    location                     = optional(string)
    sku                          = optional(string, "Standard")
    storage_mode_type            = optional(string, "LocallyRedundant")
    cross_region_restore_enabled = optional(bool, false)
    soft_delete_enabled          = optional(bool, true)
    vm_backup_policies = optional(map(object({
      name                  = optional(string)
      timezone              = optional(string, "UTC")
      frequency             = optional(string, "Daily")
      time                  = optional(string, "23:00")
      retention_daily_count = optional(number, 30)
      retention_weekly = optional(object({
        count    = number
        weekdays = list(string)
      }), null)
      retention_monthly = optional(object({
        count    = number
        weekdays = list(string)
        weeks    = list(string)
      }), null)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "mssql_servers" {
  description = "Map of Microsoft SQL Servers to provision using the mssql_server child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    location                      = optional(string)
    server_version                = optional(string, "12.0")
    administrator_login           = optional(string, "sqladmin")
    administrator_login_password  = optional(string, null)
    minimum_tls_version           = optional(string, "1.2")
    public_network_access_enabled = optional(bool, false)
    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool, false)
    }), null)
    databases = optional(map(object({
      name               = optional(string)
      sku_name           = optional(string, "Basic")
      max_size_gb        = optional(number, 2)
      geo_backup_enabled = optional(bool, false)
      collation          = optional(string, "SQL_Latin1_General_CP1_CI_AS")
      tags               = optional(map(string), {})
    })), {})
    firewall_rules = optional(map(object({
      name             = optional(string)
      start_ip_address = string
      end_ip_address   = string
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "servicebus_namespaces" {
  description = "Map of ServiceBus Namespaces to provision using the servicebus_namespace child module."
  type = map(object({
    name                          = string
    resource_group_key            = string
    location                      = optional(string)
    sku                           = optional(string, "Standard")
    capacity                      = optional(number, null)
    minimum_tls_version           = optional(string, "1.2")
    public_network_access_enabled = optional(bool, true)
    queues = optional(map(object({
      name                                 = optional(string)
      max_size_in_megabytes                = optional(number, 1024)
      dead_lettering_on_message_expiration = optional(bool, true)
      default_message_ttl                  = optional(string, "P14D")
      lock_duration                        = optional(string, "PT1M")
      max_delivery_count                   = optional(number, 10)
      requires_session                     = optional(bool, false)
      requires_duplicate_detection         = optional(bool, false)
    })), {})
    topics = optional(map(object({
      name                         = optional(string)
      max_size_in_megabytes        = optional(number, 1024)
      default_message_ttl          = optional(string, "P14D")
      requires_duplicate_detection = optional(bool, false)
      support_ordering             = optional(bool, false)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "key_vault_secrets" {
  description = "Map of Key Vault Secret collections to provision using the key_vault_secret child module."
  type = map(object({
    key_vault_key = optional(string)
    key_vault_id  = optional(string)
    secrets = map(object({
      name            = optional(string)
      value           = string
      content_type    = optional(string, null)
      not_before_date = optional(string, null)
      expiration_date = optional(string, null)
      tags            = optional(map(string), {})
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "monitor_action_groups" {
  description = "Map of Monitor Action Groups to provision using the monitor_action_group module."
  type = map(object({
    name               = string
    resource_group_key = string
    short_name         = string
    enabled            = optional(bool, true)
    location           = optional(string, "global")
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    sms_receivers = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })), [])
    webhook_receivers = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "monitor_metric_alerts" {
  description = "Map of Monitor Metric Alerts to provision using the monitor_metric_alert module."
  type = map(object({
    name               = string
    resource_group_key = string
    scopes = list(object({
      type = optional(string, "custom")
      key  = optional(string)
      id   = optional(string)
    }))
    description       = optional(string)
    severity          = optional(number, 2)
    frequency         = optional(string, "PT1M")
    window_size       = optional(string, "PT5M")
    action_group_keys = optional(list(string), [])
    criteria = optional(list(object({
      metric_namespace       = string
      metric_name            = string
      aggregation            = string
      operator               = string
      threshold              = number
      skip_metric_validation = optional(bool, false)
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), [])
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "event_grid_topics" {
  description = "Map of Event Grid Topics to provision using the event_grid_topic module."
  type = map(object({
    name               = string
    resource_group_key = string
    location           = optional(string)
    input_schema       = optional(string, "EventGridSchema")
    tags               = optional(map(string), {})
  }))
  default = {}
}
