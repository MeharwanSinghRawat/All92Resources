resource "azurerm_function_app_function" "functions" {
  for_each = var.functions

  name            = coalesce(each.value.name, each.key)
  function_app_id = azurerm_linux_function_app.function_app.id
  config_json     = each.value.config_json
  language        = each.value.language
  enabled         = each.value.enabled
  test_data       = each.value.test_data

  dynamic "file" {
    for_each = each.value.files
    content {
      name    = coalesce(file.value.name, file.key)
      content = file.value.content
    }
  }
}
