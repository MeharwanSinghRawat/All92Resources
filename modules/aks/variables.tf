variable "name" {
  description = "(Required) The name of the Managed Kubernetes Cluster to create."
  type        = string

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 63 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.name))
    error_message = "AKS cluster name must be between 2 and 63 characters, start and end with an alphanumeric character, and contain only alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Managed Kubernetes Cluster will be deployed."
  type        = string
}

variable "dns_prefix" {
  description = "(Optional) DNS prefix specified when creating the managed cluster. If omitted, defaults to var.name."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are 'Free', 'Standard', and 'Premium'."
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of 'Free', 'Standard', or 'Premium'."
  }
}

variable "private_cluster_enabled" {
  description = "(Optional) Should this Kubernetes Cluster have its API server accessible only from internal private network. Defaults to false."
  type        = bool
  default     = false
}

variable "workload_identity_enabled" {
  description = "(Optional) Whether Azure AD Workload Identity is enabled for this cluster. Defaults to true."
  type        = bool
  default     = true
}

variable "oidc_issuer_enabled" {
  description = "(Optional) Enable OpenID Connect issuer for the cluster. Defaults to true."
  type        = bool
  default     = true
}

variable "node_resource_group" {
  description = "(Optional) The name of the Resource Group where the Kubernetes Nodes will be created."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "(Required) Configuration of the default system node pool."
  type = object({
    name                         = optional(string, "system")
    vm_size                      = optional(string, "Standard_D2s_v6")
    node_count                   = optional(number, 1)
    enable_auto_scaling          = optional(bool, false)
    min_count                    = optional(number, null)
    max_count                    = optional(number, null)
    os_disk_size_gb              = optional(number, 30)
    os_disk_type                 = optional(string, "Managed")
    vnet_subnet_id               = optional(string, null)
    zones                        = optional(list(string), [])
    node_labels                  = optional(map(string), {})
    node_taints                  = optional(list(string), [])
    only_critical_addons_enabled = optional(bool, false)
    temporary_name_for_rotation  = optional(string, "systemtmp")
    tags                         = optional(map(string), {})
  })
}

variable "identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Possible values are 'SystemAssigned' and 'UserAssigned'."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "identity_type must be either 'SystemAssigned' or 'UserAssigned'."
  }
}

variable "user_assigned_identity_id" {
  description = "(Optional) The ID of a user assigned identity when identity_type is UserAssigned."
  type        = string
  default     = null
}

variable "network_profile" {
  description = "(Optional) Network profile configuration for AKS."
  type = object({
    network_plugin      = optional(string, "azure")
    network_plugin_mode = optional(string, null)
    network_policy      = optional(string, "azure")
    dns_service_ip      = optional(string, "172.16.0.10")
    service_cidr        = optional(string, "172.16.0.0/16")
    pod_cidr            = optional(string, null)
    load_balancer_sku   = optional(string, "standard")
    outbound_type       = optional(string, "loadBalancer")
  })
  default = {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "172.16.0.10"
    service_cidr      = "172.16.0.0/16"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }
}

variable "azure_active_directory_role_based_access_control" {
  description = "(Optional) Azure Active Directory Role Based Access Control block."
  type = object({
    azure_rbac_enabled     = optional(bool, true)
    admin_group_object_ids = optional(list(string), [])
    tenant_id              = optional(string, null)
  })
  default = {
    azure_rbac_enabled = true
  }
}

variable "key_vault_secrets_provider_enabled" {
  description = "(Optional) Whether the Azure Key Vault Secrets Provider addon is enabled."
  type        = bool
  default     = false
}

variable "secret_rotation_enabled" {
  description = "(Optional) Should the Azure Key Vault Secrets Provider secrets be automatically rotated?"
  type        = bool
  default     = false
}

variable "node_pools" {
  description = "(Optional) Map of additional worker node pools to create."
  type = map(object({
    name                = optional(string)
    vm_size             = optional(string, "Standard_D2s_v6")
    enable_auto_scaling = optional(bool, false)
    node_count          = optional(number, 1)
    min_count           = optional(number, null)
    max_count           = optional(number, null)
    os_disk_size_gb     = optional(number, 30)
    os_disk_type        = optional(string, "Managed")
    vnet_subnet_id      = optional(string, null)
    mode                = optional(string, "User")
    zones               = optional(list(string), [])
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Managed Kubernetes Cluster."
  type        = map(string)
  default     = {}
}
