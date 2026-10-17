output "resource_groups" {
  description = "Map of provisioned resource groups with their details."
  value = {
    for k, v in module.resource_group : k => {
      id       = v.id
      name     = v.name
      location = v.location
      tags     = v.tags
      lock_id  = v.lock_id
    }
  }
}

output "virtual_networks" {
  description = "Map of provisioned virtual networks with their details and subnets."
  value = {
    for k, v in module.virtual_network : k => {
      id                  = v.id
      name                = v.name
      resource_group_name = v.resource_group_name
      location            = v.location
      address_space       = v.address_space
      subnets             = v.subnets
      subnet_ids          = v.subnet_ids
    }
  }
}

output "network_security_groups" {
  description = "Map of provisioned network security groups with their IDs and rules."
  value = {
    for k, v in module.network_security_group : k => {
      id                = v.id
      name              = v.name
      location          = v.location
      security_rule_ids = v.security_rule_ids
    }
  }
}

output "storage_accounts" {
  description = "Map of provisioned storage accounts with their endpoints and metadata."
  value = {
    for k, v in module.storage_account : k => {
      id                    = v.id
      name                  = v.name
      location              = v.location
      primary_blob_endpoint = v.primary_blob_endpoint
      container_ids         = v.container_ids
      file_share_ids        = v.file_share_ids
    }
  }
}

output "key_vaults" {
  description = "Map of provisioned Key Vaults with their URIs and IDs."
  value = {
    for k, v in module.key_vault : k => {
      id         = v.id
      name       = v.name
      location   = v.location
      vault_uri  = v.vault_uri
      secret_ids = v.secret_ids
      key_ids    = v.key_ids
    }
  }
}

output "private_endpoints" {
  description = "Map of provisioned Private Endpoints with their IDs and network configurations."
  value = {
    for k, v in module.private_endpoint : k => {
      id                    = v.id
      name                  = v.name
      location              = v.location
      network_interface_ids = v.network_interface_ids
      custom_dns_configs    = v.custom_dns_configs
    }
  }
}

output "aks_clusters" {
  description = "Map of provisioned Managed Kubernetes Clusters with their connection endpoints."
  value = {
    for k, v in module.aks : k => {
      id                         = v.id
      name                       = v.name
      fqdn                       = v.fqdn
      oidc_issuer_url            = v.oidc_issuer_url
      node_resource_group        = v.node_resource_group
      kubelet_identity_object_id = v.kubelet_identity_object_id
      node_pool_ids              = v.node_pool_ids
    }
  }
}

output "container_registries" {
  description = "Map of provisioned Container Registries with their login servers and endpoints."
  value = {
    for k, v in module.container_registry : k => {
      id           = v.id
      name         = v.name
      login_server = v.login_server
      location     = v.location
    }
  }
}

output "virtual_machines" {
  description = "Map of provisioned Virtual Machines with their IPs and interface details."
  value = {
    for k, v in module.virtual_machine : k => {
      id                   = v.id
      name                 = v.name
      private_ip_address   = v.private_ip_address
      public_ip_id         = v.public_ip_id
      network_interface_id = v.network_interface_id
    }
  }
}

output "application_gateways" {
  description = "Map of provisioned Application Gateways with their IDs, Public IPs, and routing endpoints."
  value = {
    for k, v in module.application_gateway : k => {
      id                       = v.id
      name                     = v.name
      public_ip_id             = v.public_ip_id
      backend_address_pool_ids = v.backend_address_pool_ids
      http_listener_ids        = v.http_listener_ids
      request_routing_rule_ids = v.request_routing_rule_ids
    }
  }
}

output "azure_firewalls" {
  description = "Map of provisioned Azure Firewalls with IDs, Private IPs, Public IPs, and Policy IDs."
  value = {
    for k, v in module.azure_firewall : k => {
      id                 = v.id
      name               = v.name
      private_ip_address = v.private_ip_address
      public_ip_id       = v.public_ip_id
      public_ip_address  = v.public_ip_address
      firewall_policy_id = v.firewall_policy_id
    }
  }
}

output "private_dns_zones" {
  description = "Map of provisioned Private DNS Zones with their IDs and link details."
  value = {
    for k, v in module.private_dns_zone : k => {
      id                       = v.id
      name                     = v.name
      resource_group_name      = v.resource_group_name
      virtual_network_link_ids = v.virtual_network_link_ids
    }
  }
}

output "postgresql_flexible_servers" {
  description = "Map of provisioned PostgreSQL Flexible Servers with their IDs, FQDNs, and configuration details."
  value = {
    for k, v in module.postgresql_flexible_server : k => {
      id                            = v.id
      name                          = v.name
      fqdn                          = v.fqdn
      administrator_login           = v.administrator_login
      public_network_access_enabled = v.public_network_access_enabled
      database_ids                  = v.database_ids
      firewall_rule_ids             = v.firewall_rule_ids
    }
  }
}

output "bastion_hosts" {
  description = "Map of provisioned Bastion Hosts with their IDs, DNS names, and Public IPs."
  value = {
    for k, v in module.bastion_host : k => {
      id           = v.id
      name         = v.name
      dns_name     = v.dns_name
      public_ip_id = v.public_ip_id
    }
  }
}

output "function_apps" {
  description = "Map of provisioned Function Apps with their IDs, Hostnames, and function IDs."
  value = {
    for k, v in module.function_app : k => {
      id                       = v.id
      name                     = v.name
      default_hostname         = v.default_hostname
      service_plan_id          = v.service_plan_id
      identity_principal_id    = v.identity_principal_id
      function_ids             = v.function_ids
      function_invocation_urls = v.function_invocation_urls
    }
  }
}

output "monitor_workspaces" {
  description = "Map of provisioned Azure Monitor Workspaces (Managed Prometheus)."
  value = {
    for k, v in module.monitor_workspace : k => {
      id                                  = v.id
      name                                = v.name
      query_endpoint                      = v.query_endpoint
      default_data_collection_endpoint_id = v.default_data_collection_endpoint_id
      default_data_collection_rule_id     = v.default_data_collection_rule_id
      prometheus_rule_group_ids           = v.prometheus_rule_group_ids
    }
  }
}

output "virtual_network_peerings" {
  description = "Map of provisioned Virtual Network Peerings with their IDs and names."
  value = {
    for k, v in module.virtual_network_peering : k => {
      id                        = v.id
      name                      = v.name
      virtual_network_name      = v.virtual_network_name
      remote_virtual_network_id = v.remote_virtual_network_id
    }
  }
}

output "public_ips" {
  description = "Map of provisioned standalone Public IPs with their IDs, names, and IP addresses."
  value = {
    for k, v in module.public_ip : k => {
      id         = v.id
      name       = v.name
      ip_address = v.ip_address
      fqdn       = v.fqdn
      zones      = v.zones
      sku        = v.sku
    }
  }
}

output "service_plans" {
  description = "Map of provisioned Azure App Service Plans with their IDs and names."
  value = {
    for k, v in module.service_plan : k => {
      id                  = v.id
      name                = v.name
      os_type             = v.os_type
      sku_name            = v.sku_name
      resource_group_name = v.resource_group_name
      location            = v.location
    }
  }
}

output "app_services" {
  description = "Map of provisioned Azure App Services (Web Apps) with their IDs, hostnames, and service plan details."
  value = {
    for k, v in module.app_service : k => {
      id               = v.id
      name             = v.name
      default_hostname = v.default_hostname
      service_plan_id  = v.service_plan_id
      principal_id     = v.principal_id
    }
  }
}

output "load_balancers" {
  description = "Map of provisioned Azure Load Balancers with their IDs and configuration details."
  value = {
    for k, v in module.load_balancer : k => {
      id                        = v.id
      name                      = v.name
      frontend_ip_configuration = v.frontend_ip_configuration
      backend_address_pool_ids  = v.backend_address_pool_ids
      probe_ids                 = v.probe_ids
      rule_ids                  = v.rule_ids
    }
  }
}

output "user_assigned_identities" {
  description = "Map of provisioned User Assigned Managed Identities."
  value = {
    for k, v in module.user_assigned_identity : k => {
      id           = v.id
      name         = v.name
      principal_id = v.principal_id
      client_id    = v.client_id
      tenant_id    = v.tenant_id
    }
  }
}

output "role_definitions" {
  description = "Map of created Custom Role Definitions."
  value = {
    for k, v in module.role_definition : k => {
      id                          = v.id
      role_definition_id          = v.role_definition_id
      role_definition_resource_id = v.role_definition_resource_id
      name                        = v.name
      scope                       = v.scope
    }
  }
}

output "role_assignments" {
  description = "Map of created Azure RBAC Role Assignments."
  value = {
    for k, v in module.role_assignment : k => {
      id                 = v.id
      name               = v.name
      scope              = v.scope
      principal_id       = v.principal_id
      role_definition_id = v.role_definition_id
    }
  }
}

output "federated_identity_credentials" {
  description = "Map of created Federated Identity Credentials."
  value = {
    for k, v in module.federated_identity_credential : k => {
      id      = v.id
      name    = v.name
      issuer  = v.issuer
      subject = v.subject
    }
  }
}

output "marketplace_role_assignments" {
  description = "Map of created Marketplace Role Assignments."
  value = {
    for k, v in module.marketplace_role_assignment : k => {
      id             = v.id
      name           = v.name
      principal_type = v.principal_type
    }
  }
}

output "pim_active_role_assignments" {
  description = "Map of created PIM Active Role Assignments."
  value = {
    for k, v in module.pim_active_role_assignment : k => {
      id                 = v.id
      scope              = v.scope
      principal_id       = v.principal_id
      role_definition_id = v.role_definition_id
    }
  }
}

output "pim_eligible_role_assignments" {
  description = "Map of created PIM Eligible Role Assignments."
  value = {
    for k, v in module.pim_eligible_role_assignment : k => {
      id                 = v.id
      scope              = v.scope
      principal_id       = v.principal_id
      role_definition_id = v.role_definition_id
    }
  }
}

output "role_management_policies" {
  description = "Map of created PIM Role Management Policies."
  value = {
    for k, v in module.role_management_policy : k => {
      id                 = v.id
      name               = v.name
      scope              = v.scope
      role_definition_id = v.role_definition_id
    }
  }
}

output "route_tables" {
  description = "Map of created Route Tables."
  value = {
    for k, v in module.route_table : k => {
      id      = v.id
      name    = v.name
      subnets = v.subnets
    }
  }
}

output "log_analytics_workspaces" {
  description = "Map of created Log Analytics Workspaces."
  value = {
    for k, v in module.log_analytics_workspace : k => {
      id           = v.id
      name         = v.name
      workspace_id = v.workspace_id
    }
  }
}

output "monitor_diagnostic_settings" {
  description = "Map of configured Diagnostic Settings."
  value = {
    for k, v in module.monitor_diagnostic_setting : k => {
      id                 = v.id
      name               = v.name
      target_resource_id = v.target_resource_id
    }
  }
}

output "nat_gateways" {
  description = "Map of created NAT Gateways."
  value = {
    for k, v in module.nat_gateway : k => {
      id            = v.id
      name          = v.name
      resource_guid = v.resource_guid
    }
  }
}

output "management_groups" {
  description = "Map of created Management Groups."
  value = {
    for k, v in module.management_group : k => {
      id           = v.id
      name         = v.name
      display_name = v.display_name
    }
  }
}

output "policy_definitions" {
  description = "Map of created Policy Definitions."
  value = {
    for k, v in module.policy_definition : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "policy_assignments" {
  description = "Map of configured Policy Assignments."
  value = {
    for k, v in module.policy_assignment : k => {
      id           = v.id
      name         = v.name
      principal_id = v.principal_id
    }
  }
}

output "consumption_budgets" {
  description = "Map of configured Consumption Budgets."
  value = {
    for k, v in module.consumption_budget : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "recovery_services_vaults" {
  description = "Map of created Recovery Services Vaults."
  value = {
    for k, v in module.recovery_services_vault : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "mssql_servers" {
  description = "Map of created Microsoft SQL Servers."
  value = {
    for k, v in module.mssql_server : k => {
      id                          = v.id
      name                        = v.name
      fully_qualified_domain_name = v.fully_qualified_domain_name
      databases                   = v.databases
    }
  }
}

output "servicebus_namespaces" {
  description = "Map of created ServiceBus Namespaces."
  value = {
    for k, v in module.servicebus_namespace : k => {
      id       = v.id
      name     = v.name
      endpoint = v.endpoint
      queues   = v.queues
      topics   = v.topics
    }
  }
}

output "key_vault_secrets" {
  description = "Map of created Key Vault Secrets collections."
  value = {
    for k, v in module.key_vault_secret : k => v.secrets
  }
}

output "monitor_action_groups" {
  description = "Map of created Monitor Action Groups."
  value = {
    for k, v in module.monitor_action_group : k => {
      id         = v.id
      name       = v.name
      short_name = v.short_name
    }
  }
}

output "monitor_metric_alerts" {
  description = "Map of created Monitor Metric Alerts."
  value = {
    for k, v in module.monitor_metric_alert : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "event_grid_topics" {
  description = "Map of created Event Grid Topics."
  value = {
    for k, v in module.event_grid_topic : k => {
      id       = v.id
      name     = v.name
      endpoint = v.endpoint
    }
  }
}
