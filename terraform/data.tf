data "azurerm_resource_group" "existing_resource_group" {
  count = local.existing_resource_group == "" ? 0 : 1

  name = local.existing_resource_group
}

data "local_file" "appjs" {
  filename = "${local.root_path}/wwwroot/assets/javascripts/app.js"
}
