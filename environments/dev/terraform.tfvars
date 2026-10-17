environment  = "dev"
project_name = "enterprise"
location     = "eastus2"

common_tags = {
  Environment = "Development"
  Project     = "EnterprisePlatform"
  ManagedBy   = "Terraform"
  CostCenter  = "IT-102"
}

resource_groups = {
  network = {
    name       = "rg-enterprise-dev-network-eastus2"
    location   = "eastus2"
    lock_level = null
    tags = {
      Tier = "Networking"
    }
  }
  app = {
    name       = "rg-enterprise-dev-app-eastus2"
    location   = "eastus2"
    lock_level = null
    tags = {
      Tier = "Application"
    }
  }
  data = {
    name       = "rg-enterprise-dev-data-eastus2"
    location   = "eastus2"
    lock_level = null
    tags = {
      Tier = "Database"
    }
  }
}

virtual_networks = {
  hub = {
    name               = "vnet-enterprise-dev-hub-eastus2"
    resource_group_key = "network"
    address_space      = ["10.10.0.0/16"]
    dns_servers        = []
    subnets = {
      gateway = {
        name             = "GatewaySubnet"
        address_prefixes = ["10.10.0.0/24"]
      }
      firewall = {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.10.1.0/24"]
      }
      management = {
        name              = "snet-mgmt"
        address_prefixes  = ["10.10.2.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      }
      appgw = {
        name             = "snet-appgw"
        address_prefixes = ["10.10.3.0/24"]
      }
      bastion = {
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.10.4.0/26"]
      }
    }
    tags = {
      Topology = "Hub"
    }
  }
  spoke = {
    name               = "vnet-enterprise-dev-spoke-eastus2"
    resource_group_key = "network"
    address_space      = ["10.20.0.0/16"]
    subnets = {
      web = {
        name              = "snet-web"
        address_prefixes  = ["10.20.1.0/24"]
        service_endpoints = ["Microsoft.Storage"]
      }
      app = {
        name              = "snet-app"
        address_prefixes  = ["10.20.2.0/24"]
        service_endpoints = ["Microsoft.KeyVault"]
      }
      data = {
        name                              = "snet-data"
        address_prefixes                  = ["10.20.3.0/24"]
        private_endpoint_network_policies = "Enabled"
      }
      postgres = {
        name             = "snet-postgres"
        address_prefixes = ["10.20.4.0/24"]
        delegations = [
          {
            name = "pg-delegation"
            service_delegation = {
              name = "Microsoft.DBforPostgreSQL/flexibleServers"
              actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action"
              ]
            }
          }
        ]
      }
    }
    tags = {
      Topology = "Spoke"
    }
  }
}

network_security_groups = {
  web = {
    name               = "nsg-enterprise-dev-web-eastus2"
    resource_group_key = "network"
    security_rules = {
      allow_https = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "VirtualNetwork"
        description                = "Allow HTTPS inbound from Internet"
      }
      allow_http = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "VirtualNetwork"
        description                = "Allow HTTP inbound from Internet"
      }
    }
    subnet_associations = {
      web_subnet = {
        vnet_key   = "spoke"
        subnet_key = "web"
      }
    }
    tags = {
      Tier = "Web"
    }
  }
  app = {
    name               = "nsg-enterprise-dev-app-eastus2"
    resource_group_key = "network"
    security_rules = {
      allow_app_traffic = {
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "10.20.2.0/24"
        description                = "Allow inbound traffic from Web tier to App tier"
      }
    }
    subnet_associations = {
      app_subnet = {
        vnet_key   = "spoke"
        subnet_key = "app"
      }
    }
    tags = {
      Tier = "App"
    }
  }
  mgmt = {
    name               = "nsg-enterprise-dev-mgmt-eastus2"
    resource_group_key = "network"
    security_rules = {
      allow_ssh = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
        description                = "Allow inbound SSH for Management VM"
      }
    }
    subnet_associations = {
      mgmt_subnet = {
        vnet_key   = "hub"
        subnet_key = "management"
      }
    }
    tags = {
      Tier = "Management"
    }
  }
}

storage_accounts = {
  data_store = {
    name                     = "stentdevdata001"
    resource_group_key       = "data"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    min_tls_version          = "TLS1_2"

    blob_versioning_enabled         = true
    blob_delete_retention_days      = 7
    container_delete_retention_days = 7

    network_rules = {
      default_action             = "Allow"
      ip_rules                   = []
      virtual_network_subnet_ids = []
      subnet_references = [
        {
          vnet_key   = "hub"
          subnet_key = "management"
        }
      ]
      bypass = ["AzureServices"]
    }

    containers = {
      appdata = {
        name                  = "appdata"
        container_access_type = "private"
      }
      backups = {
        name                  = "backups"
        container_access_type = "private"
      }
    }

    file_shares = {
      config = {
        name  = "configs"
        quota = 50
      }
    }

    tags = {
      Tier = "Data"
    }
  }
}

key_vaults = {
  app_vault = {
    name                            = "kv-ent-dev-app-eastus2"
    resource_group_key              = "app"
    sku_name                        = "standard"
    enabled_for_deployment          = false
    enabled_for_disk_encryption     = false
    enabled_for_template_deployment = false
    enable_rbac_authorization       = true
    purge_protection_enabled        = false
    soft_delete_retention_days      = 7
    public_network_access_enabled   = true

    network_acls = {
      default_action             = "Allow"
      bypass                     = "AzureServices"
      ip_rules                   = []
      virtual_network_subnet_ids = []
      subnet_references = [
        {
          vnet_key   = "spoke"
          subnet_key = "app"
        }
      ]
    }

    secrets = {}
    keys    = {}

    tags = {
      Tier = "Security"
    }
  }
}

private_endpoints = {
  storage_blob = {
    name               = "pe-stentdevdata001-blob"
    resource_group_key = "data"
    vnet_key           = "spoke"
    subnet_key         = "data"
    target_type        = "storage_account"
    target_key         = "data_store"
    subresource_names  = ["blob"]

    tags = {
      Tier = "Data"
    }
  }
}

aks_clusters = {
  primary = {
    name                      = "aks-enterprise-dev-eastus2"
    resource_group_key        = "app"
    dns_prefix                = "aks-ent-dev"
    sku_tier                  = "Free"
    workload_identity_enabled = true
    oidc_issuer_enabled       = true

    default_node_pool = {
      name                = "system"
      vm_size             = "Standard_D2s_v6"
      node_count          = 1
      enable_auto_scaling = false
      os_disk_size_gb     = 30
      vnet_key            = "spoke"
      subnet_key          = "app"
    }

    network_profile = {
      network_plugin    = "azure"
      network_policy    = "azure"
      dns_service_ip    = "172.16.0.10"
      service_cidr      = "172.16.0.0/16"
      load_balancer_sku = "standard"
      outbound_type     = "loadBalancer"
    }

    tags = {
      Tier = "ContainerPlatform"
    }
  }
}

container_registries = {
  primary = {
    name               = "acrmehrwandev01"
    resource_group_key = "app"
    sku                = "Standard"
    admin_enabled      = true

    tags = {
      Tier = "ContainerPlatform"
    }
  }
}

virtual_machines = {
  mgmt_jumpbox = {
    name                            = "vm-enterprise-dev-mgmt-001"
    resource_group_key              = "network"
    os_type                         = "Linux"
    size                            = "Standard_D2s_v6"
    admin_username                  = "azureuser"
    admin_password                  = "AzureDevJumpbox2026!"
    disable_password_authentication = false
    vnet_key                        = "hub"
    subnet_key                      = "management"
    enable_public_ip                = false
    public_ip_sku                   = "Standard"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "StandardSSD_LRS"
      disk_size_gb         = 30
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
    identity_type = "SystemAssigned"
    tags = {
      Role = "Jumpbox"
      Tier = "Management"
    }
  }
}

application_gateways = {
  primary = {
    name               = "agw-enterprise-dev-eastus2"
    resource_group_key = "network"
    vnet_key           = "hub"
    subnet_key         = "appgw"
    sku = {
      name = "Standard_v2"
      tier = "Standard_v2"
    }
    autoscale_configuration = {
      min_capacity = 1
      max_capacity = 2
    }
    public_ip_key = "appgw"
    frontend_ports = {
      http = {
        port = 80
        name = "port_80"
      }
    }
    backend_address_pools = {
      aks_backend = {
        name         = "aks-backend-pool"
        fqdns        = []
        ip_addresses = []
      }
    }
    backend_http_settings = {
      http = {
        name                  = "http-settings"
        port                  = 80
        protocol              = "Http"
        cookie_based_affinity = "Disabled"
        request_timeout       = 30
      }
    }
    http_listeners = {
      http = {
        name     = "http-listener"
        protocol = "Http"
      }
    }
    request_routing_rules = {
      default = {
        name                      = "http-routing-rule"
        rule_type                 = "Basic"
        http_listener_key         = "http"
        backend_address_pool_key  = "aks_backend"
        backend_http_settings_key = "http"
        priority                  = 100
      }
    }
    tags = {
      Tier = "Networking"
      Role = "ApplicationGateway"
    }
  }
}

# ==============================================================================
# Azure Firewall Configuration
# ==============================================================================
azure_firewalls = {}

private_dns_zones = {
  postgres = {
    name               = "privatelink.postgres.database.azure.com"
    resource_group_key = "network"
    virtual_network_links = {
      spoke = {
        vnet_key             = "spoke"
        registration_enabled = false
      }
    }
    tags = {
      Tier = "Networking"
      Role = "PrivateDNS"
    }
  }
}

# ==============================================================================
# PostgreSQL Flexible Server Configuration
# ==============================================================================
postgresql_flexible_servers = {}

bastion_hosts = {
  primary = {
    name               = "bas-enterprise-dev-eastus2"
    resource_group_key = "network"
    vnet_key           = "hub"
    subnet_key         = "bastion"
    public_ip_key      = "bastion"
    sku                = "Standard"
    scale_units        = 2
    copy_paste_enabled = true
    file_copy_enabled  = true
    ip_connect_enabled = true
    tunneling_enabled  = true
    tags = {
      Tier = "Management"
      Role = "BastionHost"
    }
  }
}

# ==============================================================================
# Function App Configuration
# (Disabled: Subscription has 0 quota for Consumption Y1 in eastus2)
# ==============================================================================
function_apps = {}



monitor_workspaces = {
  primary = {
    name                          = "amw-enterprise-dev-eastus2"
    resource_group_key            = "app"
    public_network_access_enabled = true
    prometheus_rule_groups = {
      cluster_health = {
        name         = "amw-enterprise-dev-cluster-health"
        description  = "Node and pod Prometheus alerting rules"
        cluster_name = "aks-enterprise-dev-eastus2"
        interval     = "PT1M"
        rules = [
          {
            alert      = "NodeDiskPressure"
            expression = "node_disk_usage_percentage > 85"
            severity   = 2
            for        = "PT5M"
            labels = {
              severity = "warning"
            }
            annotations = {
              description = "Node disk usage is above 85% for more than 5 minutes."
            }
          }
        ]
      }
    }
    tags = {
      Tier = "Observability"
      Role = "ManagedPrometheus"
    }
  }
}

virtual_network_peerings = {
  hub_to_spoke = {
    vnet_key                     = "hub"
    remote_vnet_key              = "spoke"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
  spoke_to_hub = {
    vnet_key                     = "spoke"
    remote_vnet_key              = "hub"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

public_ips = {
  bastion = {
    name               = "pip-enterprise-dev-bastion-eastus2"
    resource_group_key = "network"
    allocation_method  = "Static"
    sku                = "Standard"
    zones              = ["1", "2", "3"]
    tags = {
      Tier = "Management"
      Role = "BastionPublicIP"
    }
  }
  appgw = {
    name               = "pip-enterprise-dev-appgw-eastus2"
    resource_group_key = "network"
    allocation_method  = "Static"
    sku                = "Standard"
    zones              = ["1", "2", "3"]
    tags = {
      Tier = "Networking"
      Role = "AppGatewayPublicIP"
    }
  }

}

# ==============================================================================
# Azure App Service Plan & App Service Configuration
# (Disabled: Subscription has 0 quota for B1 VMs in eastus2)
# ==============================================================================
service_plans = {}

app_services = {}


load_balancers = {
  internal_app = {
    name               = "lb-enterprise-dev-internal-eastus2"
    resource_group_key = "network"
    sku                = "Standard"
    frontend_ip_configurations = {
      internal = {
        name               = "fip-internal-app"
        vnet_key           = "spoke"
        subnet_key         = "app"
        private_ip_address = "10.20.2.100"
      }
    }
    backend_address_pools = {
      app_backend = {
        name = "pool-app-backend"
      }
    }
    probes = {
      http_probe = {
        name         = "prb-http-8080"
        protocol     = "Http"
        port         = 8080
        request_path = "/health"
      }
    }
    load_balancing_rules = {
      app_rule = {
        name                           = "rule-app-traffic"
        frontend_ip_configuration_name = "fip-internal-app"
        backend_address_pool_name      = "app_backend"
        probe_name                     = "http_probe"
        protocol                       = "Tcp"
        frontend_port                  = 8080
        backend_port                   = 8080
      }
    }
    tags = {
      Tier = "Networking"
      Role = "InternalLoadBalancer"
    }
  }
}

user_assigned_identities = {
  app_workload = {
    name               = "id-enterprise-dev-app-eastus2"
    resource_group_key = "app"
    tags = {
      Tier = "Security"
      Role = "WorkloadIdentity"
    }
  }
}

role_definitions = {}

role_assignments = {}


# ==============================================================================
# Workload Federated Identity Credentials
# ==============================================================================
federated_identity_credentials = {}

# ==============================================================================
# Azure Marketplace Role Assignments
# ==============================================================================
marketplace_role_assignments = {}

# ==============================================================================
# Privileged Identity Management (PIM) - Role Assignments & Policies
# ==============================================================================
pim_active_role_assignments   = {}
pim_eligible_role_assignments = {}
role_management_policies      = {}

# ==============================================================================
# Azure Route Tables (UDR) Configuration
# Example: Spoke-to-Firewall Egress routing
# ==============================================================================
route_tables = {
  spoke_udr = {
    name                          = "rt-enterprise-dev-spoke-eastus2"
    resource_group_key            = "network"
    bgp_route_propagation_enabled = true
    routes = {
      internal_traffic = {
        address_prefix = "10.10.0.0/16"
        next_hop_type  = "VnetLocal"
      }
    }
    subnet_associations = {
      app = {
        vnet_key   = "spoke"
        subnet_key = "app"
      }
    }
    tags = {
      Tier = "Networking"
      Role = "RouteTable"
    }
  }
}

# ==============================================================================
# Azure Log Analytics Workspaces
# Central sink for logs and telemetry
# ==============================================================================
log_analytics_workspaces = {
  central = {
    name               = "law-enterprise-dev-eastus2"
    resource_group_key = "app"
    sku                = "PerGB2018"
    retention_in_days  = 30
    tags = {
      Tier = "Observability"
      Role = "LogAnalytics"
    }
  }
}

# ==============================================================================
# Azure Monitor Diagnostic Settings
# Automatic audit and metrics log streaming
# ==============================================================================
monitor_diagnostic_settings = {
  kv_diag = {
    name                        = "diag-kv-app"
    target_resource_type        = "key_vault"
    target_resource_key         = "app_vault"
    log_analytics_workspace_key = "central"
    enabled_log_category_groups = ["allLogs"]
    metric_categories           = ["AllMetrics"]
  }
}

# ==============================================================================
# Azure NAT Gateways
# ==============================================================================
nat_gateways = {}

# ==============================================================================
# Azure Management Groups (CAF Hierarchy)
# ==============================================================================
management_groups = {}

# ==============================================================================
# Azure Policy Definitions (Governance as Code)
# ==============================================================================
policy_definitions = {}

# ==============================================================================
# Azure Policy Assignments
# ==============================================================================
policy_assignments = {}


# ==============================================================================
# Azure Consumption Budgets (FinOps Cost Control)
# ==============================================================================
consumption_budgets = {
  app_monthly = {
    name               = "budget-app-monthly"
    scope_type         = "resource_group"
    resource_group_key = "app"
    amount             = 500
    time_grain         = "Monthly"
    time_period = {
      start_date = "2026-10-01T00:00:00Z"
    }
    notifications = {
      warn_80 = {
        operator       = "GreaterThan"
        threshold      = 80
        threshold_type = "Actual"
        contact_emails = ["finops-alerts@enterprise.com"]
      }
    }
  }
}

# ==============================================================================
# Azure Recovery Services Vaults (Backup & Disaster Recovery)
# ==============================================================================
recovery_services_vaults = {
  app_vault = {
    name                = "rsv-enterprise-dev-eastus2"
    resource_group_key  = "app"
    sku                 = "Standard"
    storage_mode_type   = "LocallyRedundant"
    soft_delete_enabled = true
    vm_backup_policies = {
      daily_policy = {
        name                  = "daily-vm-backup"
        frequency             = "Daily"
        time                  = "23:00"
        retention_daily_count = 14
      }
    }
    tags = {
      Tier = "Management"
      Role = "BackupVault"
    }
  }
}

# ==============================================================================
# Azure SQL Server & Databases
# (Disabled: Microsoft restricts Azure SQL provisioning in eastus2 for this subscription)
# ==============================================================================
mssql_servers = {}


# ==============================================================================
# Azure Service Bus Namespaces & Messaging
# ==============================================================================
servicebus_namespaces = {
  primary_bus = {
    name               = "sb-enterprise-dev-mehrwan01"
    resource_group_key = "app"
    sku                = "Standard"
    queues = {
      task_queue = {
        max_size_in_megabytes = 1024
      }
    }
    tags = {
      Tier = "Integration"
      Role = "ServiceBus"
    }
  }
}

# ==============================================================================
# Azure Key Vault Secrets
# (Disabled: Contributor SPN does not have Key Vault Data Plane RBAC permissions)
# ==============================================================================
key_vault_secrets = {}


# ==============================================================================
# Azure Monitor Action Groups (Multi-Channel Notifications)
# ==============================================================================
monitor_action_groups = {
  devops = {
    name               = "ag-enterprise-devops-dev"
    resource_group_key = "app"
    short_name         = "devops-alert"
    email_receivers = [
      {
        name          = "lead-admin"
        email_address = "admin@example.com"
      }
    ]
    tags = {
      Tier = "Observability"
    }
  }
}

# ==============================================================================
# Azure Monitor Metric Alerts
# ==============================================================================
monitor_metric_alerts = {
  vm_high_cpu = {
    name               = "alert-vm-jumpbox-high-cpu"
    resource_group_key = "network"
    scopes = [
      {
        type = "vm"
        key  = "mgmt_jumpbox"
      }
    ]
    description = "Alert when Jumpbox VM CPU exceeds 80%"
    severity    = 2
    criteria = [
      {
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Percentage CPU"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 80
      }
    ]
    action_group_keys = ["devops"]
    tags = {
      Tier = "Observability"
    }
  }
}

# ==============================================================================
# Azure Event Grid Topics (Serverless Event Pub/Sub)
# ==============================================================================
event_grid_topics = {
  platform_events = {
    name               = "egt-enterprise-platform-dev"
    resource_group_key = "app"
    tags = {
      Tier = "Messaging"
    }
  }
}
