variable "name" {
  description = "(Optional) The name or UUID of this Management Group. Changing this forces a new resource to be created. If not provided, a UUID will be generated."
  type        = string
  default     = null
}

variable "display_name" {
  description = "(Optional) A friendly name for this Management Group. If not specified, name will be used."
  type        = string
  default     = null
}

variable "parent_management_group_id" {
  description = "(Optional) The ID of the Parent Management Group."
  type        = string
  default     = null
}

variable "subscription_ids" {
  description = "(Optional) A list of Subscription GUIDs which should be assigned to the Management Group."
  type        = list(string)
  default     = []
}
