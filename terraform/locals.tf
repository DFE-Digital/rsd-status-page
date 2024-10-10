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

  allowed_files = [for file in fileset("${local.root_path}/wwwroot/", "**") : file if(!contains(keys(local.templates), file))]

  templates = {
    "index.html.tftpl" : templatefile(
      "${local.root_path}/wwwroot/index.html.tftpl", {
        base_url : trim(azurerm_storage_account.storage.primary_web_endpoint, "/")
        title : "RSD Status Page"
      }
    ),
    "assets/javascripts/app.js" : replace(
      data.local_file.appjs.content,
      "const endpoints = [];",
      <<DOC
      const endpoints = [
        ${join(",", var.endpoints)}
      ];
      DOC
    )
  }

  tags = var.tags
}
