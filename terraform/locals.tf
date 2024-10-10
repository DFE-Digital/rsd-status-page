locals {
  environment             = var.environment
  project_name            = var.project_name
  resource_prefix         = "${local.environment}${local.project_name}"
  azure_location          = var.azure_location
  existing_resource_group = var.existing_resource_group
  resource_group          = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  root_path               = abspath("${path.module}/..")

  content_types = {
    css   = "text/css"
    html  = "text/html"
    js    = "application/javascript"
    png   = "image/png"
    svg   = "image/svg+xml"
    woff  = "font/woff"
    woff2 = "font/woff2"
  }

  web_pages = {
    "${azurerm_storage_account.storage.name}" : {
      "index.html" : templatefile(
        "${local.root_path}/wwwroot/index.html.tftpl", {
          base_url : trim(azurerm_storage_account.storage.primary_web_endpoint, "/")
          title : "RSD Status Page"
        }
      ),
    }
  }

  tags = var.tags
}
