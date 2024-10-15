data "azurerm_resource_group" "existing_resource_group" {
  count = local.existing_resource_group == "" ? 0 : 1

  name = local.existing_resource_group
}

data "local_file" "appjs" {
  filename = "${local.root_path}/wwwroot/assets/javascripts/app.js"
}

data "azurerm_linux_function_app" "functions" {
  for_each = local.function_apps

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_function_app_host_keys" "function_key" {
  for_each = local.function_apps

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
