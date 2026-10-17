variable "name" {
  description = "(Required) The name of the Virtual Machine. Must be 1-64 characters for Linux or 1-15 characters for Windows."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Virtual Machine should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure region where the Virtual Machine will be created."
  type        = string
}

variable "os_type" {
  description = "(Optional) The operating system type. Possible values are 'Linux' and 'Windows'."
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "os_type must be either 'Linux' or 'Windows'."
  }
}

variable "size" {
  description = "(Optional) The SKU which should be used for this Virtual Machine, such as 'Standard_D2s_v6'."
  type        = string
  default     = "Standard_D2s_v6"
}

variable "admin_username" {
  description = "(Optional) The username of the local administrator used for the Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_ssh_key" {
  description = "(Optional) The Public SSH Key used for authentication on this Linux Virtual Machine."
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to true for Linux."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet where the Network Interface of this Virtual Machine should be located."
  type        = string
}

variable "private_ip_address_allocation" {
  description = "(Optional) The allocation method used for the Private IP Address. Possible values are 'Dynamic' and 'Static'."
  type        = string
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "(Optional) The Static IP Address which should be assigned to this Virtual Machine."
  type        = string
  default     = null
}

variable "public_ip_id" {
  description = "(Optional) The ID of a Public IP Address to attach to the Network Interface. Defaults to null."
  type        = string
  default     = null
}

variable "os_disk" {
  description = "(Optional) OS Disk configuration block."
  type = object({
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_LRS")
    disk_size_gb         = optional(number, 30)
  })
  default = {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
  }
}

variable "source_image_reference" {
  description = "(Optional) Source image reference block for the operating system."
  type = object({
    publisher = optional(string, "Canonical")
    offer     = optional(string, "0001-com-ubuntu-server-jammy")
    sku       = optional(string, "22_04-lts-gen2")
    version   = optional(string, "latest")
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "data_disks" {
  description = "(Optional) Map of additional managed data disks to attach to the Virtual Machine."
  type = map(object({
    name                 = optional(string)
    disk_size_gb         = number
    lun                  = number
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_LRS")
  }))
  default = {}
}

variable "custom_data" {
  description = "(Optional) Base64 encoded cloud-init / custom data script."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "(Optional) Type of Managed Identity assigned to the Virtual Machine."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Virtual Machine and attached resources."
  type        = map(string)
  default     = {}
}
