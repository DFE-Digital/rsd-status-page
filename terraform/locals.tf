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
        ${join(",", local.endpoints)}
      ];
      DOC
    )
  }
  endpoints = [for label, endpoint in local.function_app_endpoints : <<DOC
    { label: "${label}", endpoint: "${endpoint}" }
  DOC
  ]

  function_apps = var.function_apps
  function_app_endpoints = {
    for label, function in local.function_apps :
    label => "https://${data.azurerm_linux_function_app.functions[label].default_hostname}/api/http_trigger?code=${data.azurerm_function_app_host_keys.function_key[label].default_function_key}"
  }

  tags = var.tags
}
