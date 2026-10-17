output "id" {
  description = "The ID of the Linux Function App."
  value       = azurerm_linux_function_app.function_app.id
}

output "name" {
  description = "The Name of the Linux Function App."
  value       = azurerm_linux_function_app.function_app.name
}

output "default_hostname" {
  description = "The default hostname of the Function App (e.g. '<name>.azurewebsites.net')."
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "service_plan_id" {
  description = "The ID of the App Service Plan hosting the Function App."
  value       = azurerm_linux_function_app.function_app.service_plan_id
}

output "identity_principal_id" {
  description = "The Principal ID of the SystemAssigned Managed Identity, if enabled."
  value       = try(azurerm_linux_function_app.function_app.identity[0].principal_id, null)
}

output "function_ids" {
  description = "Map of individual function names to their Azure resource IDs."
  value       = { for k, v in azurerm_function_app_function.functions : k => v.id }
}

output "function_invocation_urls" {
  description = "Map of individual function names to their invocation URLs."
  value       = { for k, v in azurerm_function_app_function.functions : k => v.invocation_url }
}
