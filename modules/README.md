# Enterprise Azure Terraform Child Module Registry

Production-grade, highly reusable, modular Terraform child modules designed for Azure Landing Zones (CAF), Platform Engineering, and multi-team workload deployments.

---

## Architecture & Module Catalog (52 Modules)

### 1. Governance, Policy as Code & FinOps (4 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`management_group`](./management_group) | `azurerm_management_group` | CAF hierarchy management groups (Platform, Workloads, Sandbox). |
| [`policy_definition`](./policy_definition) | `azurerm_policy_definition` | Custom Azure Governance rules, tagging standards & CIS benchmarks. |
| [`policy_assignment`](./policy_assignment) | `azurerm_subscription_policy_assignment`, `azurerm_resource_group_policy_assignment` | Enforces policies at Subscription/RG level with remediation identities. |
| [`consumption_budget`](./consumption_budget) | `azurerm_consumption_budget_subscription`, `azurerm_consumption_budget_resource_group` | FinOps spend tracking with automated email & action group alerts. |

### 2. Authorization, Identity & RBAC (8 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`user_assigned_identity`](./user_assigned_identity) | `azurerm_user_assigned_identity` | Standalone managed workload identity for VMs, Apps, AKS. |
| [`role_assignment`](./role_assignment) | `azurerm_role_assignment` | Standard Azure RBAC assignment across subscription, RG, or resource scopes. |
| [`role_definition`](./role_definition) | `azurerm_role_definition` | Custom RBAC role definitions with actions and data actions. |
| [`federated_identity_credential`](./federated_identity_credential) | `azurerm_federated_identity_credential` | Passwordless workload identity federation (AKS, GitHub Actions, OIDC). |
| [`pim_active_role_assignment`](./pim_active_role_assignment) | `azurerm_pim_active_role_assignment` | Privileged Identity Management time-bound active role assignments. |
| [`pim_eligible_role_assignment`](./pim_eligible_role_assignment) | `azurerm_pim_eligible_role_assignment` | PIM eligible roles requiring just-in-time elevation and approval. |
| [`role_management_policy`](./role_management_policy) | `azurerm_role_management_policy` | PIM governance rules (activation duration, MFA, approval workflows). |
| [`marketplace_role_assignment`](./marketplace_role_assignment) | `azurerm_marketplace_role_assignment` | Role assignments for Azure Marketplace publishers and offers. |

### 3. Core, Hybrid & Global Networking (Hub-Spoke & Transit Architecture) (15 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`virtual_network`](./virtual_network) | `azurerm_virtual_network`, `azurerm_subnet` | Virtual Networks, delegated subnets, private endpoint subnets. |
| [`virtual_network_peering`](./virtual_network_peering) | `azurerm_virtual_network_peering` | Bidirectional low-latency VNet peerings between Hub & Spokes. |
| [`virtual_network_gateway`](./virtual_network_gateway) | `azurerm_virtual_network_gateway`, local gateways, connections | Hybrid on-prem connectivity via Site-to-Site IPsec VPN, BGP, or ExpressRoute. |
| [`virtual_wan`](./virtual_wan) | `azurerm_virtual_wan`, `azurerm_virtual_hub`, hub connections | Global transit networking with Microsoft backbone, regional vHubs, and branch routing. |
| [`route_table`](./route_table) | `azurerm_route_table`, `azurerm_route` | UDR (User-Defined Routing) for egress inspection via Azure Firewall. |
| [`network_security_group`](./network_security_group) | `azurerm_network_security_group`, `azurerm_network_security_rule` | Microsegmentation firewall rules and subnet associations. |
| [`public_ip`](./public_ip) | `azurerm_public_ip` | Static Standard SKU Public IP addresses with availability zones. |
| [`nat_gateway`](./nat_gateway) | `azurerm_nat_gateway`, pip/subnet associations | Scalable, highly available outbound Internet egress for private subnets. |
| [`azure_firewall`](./azure_firewall) | `azurerm_firewall`, network/app rule collections | Centralized Layer 4-7 firewall with Threat Intelligence. |
| [`application_gateway`](./application_gateway) | `azurerm_application_gateway` | Layer 7 Application Load Balancer with WAF v2 and SSL termination. |
| [`front_door`](./front_door) | `azurerm_cdn_frontdoor_profile`, endpoints, origin groups, routes | Global CDN, Anycast Layer 7 routing, edge caching, and Private Link backends. |
| [`load_balancer`](./load_balancer) | `azurerm_lb`, backend pools, probes, rules | Internal Layer 4 Load Balancer for private microservices. |
| [`private_dns_zone`](./private_dns_zone) | `azurerm_private_dns_zone`, `azurerm_private_dns_zone_virtual_network_link` | Private DNS resolution for PaaS services linked to VNets. |
| [`private_endpoint`](./private_endpoint) | `azurerm_private_endpoint` | Secure private link access for Storage, KeyVault, SQL, etc. |
| [`bastion_host`](./bastion_host) | `azurerm_bastion_host` | Secure browser-based TLS jumpbox access without public IPs on VMs. |

### 4. Observability & Platform Monitoring (5 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`log_analytics_workspace`](./log_analytics_workspace) | `azurerm_log_analytics_workspace` | Centralized platform log repository and SIEM telemetry sink. |
| [`monitor_diagnostic_setting`](./monitor_diagnostic_setting) | `azurerm_monitor_diagnostic_setting` | Mandatory diagnostic streaming for any Azure resource to Log Analytics. |
| [`monitor_workspace`](./monitor_workspace) | `azurerm_monitor_workspace` | Azure Managed Prometheus workspace for Kubernetes metrics. |
| [`monitor_action_group`](./monitor_action_group) | `azurerm_monitor_action_group` | Multi-channel alert routing (Email, SMS, Webhook, Logic App, Function). |
| [`monitor_metric_alert`](./monitor_metric_alert) | `azurerm_monitor_metric_alert` | Metric threshold alerts and ML dynamic anomaly detection. |

### 5. Compute & Containers (7 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`virtual_machine`](./virtual_machine) | `azurerm_linux_virtual_machine`, `azurerm_windows_virtual_machine` | Compute instances with secure NICs, cloud-init, and managed disks. |
| [`aks`](./aks) | `azurerm_kubernetes_cluster`, node pools | Azure Kubernetes Service with Azure CNI, OIDC, Workload Identity. |
| [`container_app`](./container_app) | `azurerm_container_app_environment`, `azurerm_container_app` | Serverless container apps with ingress, traffic splitting, and autoscaling. |
| [`container_registry`](./container_registry) | `azurerm_container_registry` | Private Docker container registry with georeplication and admin controls. |
| [`service_plan`](./service_plan) | `azurerm_service_plan` | Dedicated App Service hosting plan for Linux/Windows web workloads. |
| [`app_service`](./app_service) | `azurerm_linux_web_app`, `azurerm_windows_web_app` | Enterprise Web Apps with runtime stacks and App Settings. |
| [`function_app`](./function_app) | `azurerm_linux_function_app`, `azurerm_windows_function_app` | Serverless event-driven compute functions. |

### 6. Artificial Intelligence & Cognitive Services (1 Module)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`cognitive_account`](./cognitive_account) | `azurerm_cognitive_account`, `azurerm_cognitive_deployment` | Enterprise Azure AI / OpenAI services with LLM and embedding deployments. |

### 7. Data, Database & Messaging Platforms (8 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`storage_account`](./storage_account) | `azurerm_storage_account`, containers, shares | Secure Blob and File storage with customer network firewall rules. |
| [`cosmosdb_account`](./cosmosdb_account) | `azurerm_cosmosdb_account`, SQL DBs & containers | Globally distributed multi-model NoSQL databases with autoscale throughput. |
| [`redis_cache`](./redis_cache) | `azurerm_redis_cache`, firewall rules | Azure Cache for Redis for high-performance in-memory caching. |
| [`postgresql_flexible_server`](./postgresql_flexible_server) | `azurerm_postgresql_flexible_server`, databases | Enterprise managed PostgreSQL 16 with delegated subnet integration. |
| [`mssql_server`](./mssql_server) | `azurerm_mssql_server`, `azurerm_mssql_database` | Azure SQL Database and Server with automated password and firewall rules. |
| [`servicebus_namespace`](./servicebus_namespace) | `azurerm_servicebus_namespace`, queues, topics | Enterprise decoupled message queues and pub/sub topics. |
| [`event_hub_namespace`](./event_hub_namespace) | `azurerm_eventhub_namespace`, event hubs, consumer groups | High-throughput real-time event streaming and Kafka ingestion. |
| [`event_grid_topic`](./event_grid_topic) | `azurerm_eventgrid_topic`, event subscriptions | Enterprise reactive event-driven pub/sub routing to webhooks, functions, queues. |

### 8. Security & Key Management (3 Modules)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`key_vault`](./key_vault) | `azurerm_key_vault`, access policies | FIPS-compliant hardware security module for secrets, keys, and certs. |
| [`key_vault_secret`](./key_vault_secret) | `azurerm_key_vault_secret` | Lifecycle management for credentials, tokens, and connection strings. |
| [`resource_group`](./resource_group) | `azurerm_resource_group`, management locks | Resource grouping boundary with optional CanNotDelete locks. |

### 9. Backup & Business Continuity (BCDR) (1 Module)
| Module | Target Azure Resource | Description |
|---|---|---|
| [`recovery_services_vault`](./recovery_services_vault) | `azurerm_recovery_services_vault`, `azurerm_backup_policy_vm` | Centralized backup vault with custom daily/weekly/monthly VM policies. |

---

## How Other Projects & Landing Zones Consume These Modules

### Option A: Local Monorepo Reference
```hcl
module "vnet" {
  source = "../../modules/virtual_network"

  name                = "vnet-project-a-dev"
  resource_group_name = "rg-project-a-dev"
  location            = "eastus2"
  address_space       = ["10.30.0.0/16"]
}
```

### Option B: Remote Git Source Reference (Cross-Repository)
```hcl
module "aks" {
  source = "git::https://github.com/organization/azure-terraform-modules.git//modules/aks?ref=v1.0.0"

  name                = "aks-workload-prod"
  resource_group_name = "rg-workload-prod"
  location            = "eastus2"
  # ...
}
```
