resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip_id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.os_type == "Linux" ? 1 : 0
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.admin_ssh_key != null ? var.disable_password_authentication : false
  network_interface_ids           = [azurerm_network_interface.nic.id]
  custom_data                     = var.custom_data

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key
    }
  }

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                 = var.os_type == "Windows" ? 1 : 0
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
    }
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "data_disk" {
  for_each             = var.data_disks
  name                 = coalesce(each.value.name, "${var.name}-disk-${each.key}")
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = try(each.value.storage_account_type, "StandardSSD_LRS")
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each           = var.data_disks
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = var.os_type == "Linux" ? azurerm_linux_virtual_machine.vm_linux[0].id : azurerm_windows_virtual_machine.vm_windows[0].id
  lun                = each.value.lun
  caching            = try(each.value.caching, "ReadWrite")
}
