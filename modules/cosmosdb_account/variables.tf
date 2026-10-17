variable "name" {
  description = "(Required) Specifies the name of the CosmosDB Account. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the CosmosDB Account is created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region in which the CosmosDB Account is created."
  type        = string
}

variable "offer_type" {
  description = "(Required) Specifies the Offer Type to use for this CosmosDB Account - currently this can only be set to Standard."
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "(Optional) The kind of CosmosDB to create - possible values are 'GlobalDocumentDB', 'MongoDB' and 'Parse'. Defaults to 'GlobalDocumentDB'."
  type        = string
  default     = "GlobalDocumentDB"

  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB", "Parse"], var.kind)
    error_message = "kind must be one of: 'GlobalDocumentDB', 'MongoDB', 'Parse'."
  }
}

variable "automatic_failover_enabled" {
  description = "(Optional) Enable automatic failover for this Cosmos DB account. Defaults to false."
  type        = bool
  default     = false
}

variable "free_tier_enabled" {
  description = "(Optional) Enable the Free Tier pricing option for this Cosmos DB account. Defaults to false."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this CosmosDB account. Defaults to true."
  type        = bool
  default     = true
}

variable "network_acl_bypass_for_azure_services" {
  description = "(Optional) If Azure services can bypass ACLs. Defaults to false."
  type        = bool
  default     = false
}

variable "is_virtual_network_filter_enabled" {
  description = "(Optional) Enables virtual network filtering on this Cosmos DB account. Defaults to false."
  type        = bool
  default     = false
}

variable "ip_range_filter" {
  description = "(Optional) Cosmos DB IP range filter set of IP addresses/CIDRs."
  type        = set(string)
  default     = []
}

variable "virtual_network_rules" {
  description = "(Optional) List of virtual network rules to allow access."
  type = list(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = optional(bool, false)
  }))
  default = []
}

variable "consistency_policy" {
  description = "(Required) The Cosmos DB consistency policy."
  type = object({
    consistency_level       = optional(string, "Session")
    max_interval_in_seconds = optional(number, 5)
    max_staleness_prefix    = optional(number, 100)
  })
  default = {
    consistency_level = "Session"
  }
}

variable "geo_locations" {
  description = "(Optional) List of geo locations for multi-region replication. If empty, the default location is used with priority 0."
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
  default = []
}

variable "capabilities" {
  description = "(Optional) List of capability names (e.g. 'EnableServerless', 'EnableMongo', 'EnableTable')."
  type        = list(string)
  default     = []
}

variable "backup" {
  description = "(Optional) Backup policy block."
  type = object({
    type                = optional(string, "Periodic")
    interval_in_minutes = optional(number, 240)
    retention_in_hours  = optional(number, 8)
    storage_redundancy  = optional(string, "Geo")
  })
  default = {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
  }
}

variable "identity_type" {
  description = "(Optional) Type of Managed Identity ('SystemAssigned', 'UserAssigned', or null)."
  type        = string
  default     = null
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "sql_databases" {
  description = "(Optional) Map of Cosmos DB SQL databases to create."
  type = map(object({
    throughput     = optional(number, null)
    max_throughput = optional(number, null) # For autoscale
  }))
  default = {}
}

variable "sql_containers" {
  description = "(Optional) Map of Cosmos DB SQL containers to create."
  type = map(object({
    database_name       = string
    partition_key_paths = optional(list(string), ["/id"])
    throughput          = optional(number, null)
    max_throughput      = optional(number, null) # For autoscale
    default_ttl         = optional(number, null)
  }))
  default = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
