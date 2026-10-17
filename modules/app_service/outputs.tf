output "id" {
  description = "The ID of the App Service (Web App)."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].id : azurerm_windows_web_app.windows[0].id
}

output "name" {
  description = "The Name of the App Service."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].name : azurerm_windows_web_app.windows[0].name
}

output "default_hostname" {
  description = "The default hostname associated with the App Service (e.g., your-app.azurewebsites.net)."
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].default_hostname : azurerm_windows_web_app.windows[0].default_hostname
}

output "service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = var.service_plan_id
}

output "principal_id" {
  description = "The Principal ID for the System Assigned Managed Identity of the Web App."
  value = (
    var.os_type == "Linux" ?
    try(azurerm_linux_web_app.linux[0].identity[0].principal_id, null) :
    try(azurerm_windows_web_app.windows[0].identity[0].principal_id, null)
  )
}

output "outbound_ip_addresses" {
  description = "A list of outbound IP addresses of the App Service."
  value = split(
    ",",
    var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].outbound_ip_addresses : azurerm_windows_web_app.windows[0].outbound_ip_addresses
  )
}

output "possible_outbound_ip_addresses" {
  description = "A list of possible outbound IP addresses of the App Service."
  value = split(
    ",",
    var.os_type == "Linux" ? azurerm_linux_web_app.linux[0].possible_outbound_ip_addresses : azurerm_windows_web_app.windows[0].possible_outbound_ip_addresses
  )
}
