resource "azurerm_storage_account" "storage" {
  name                          = "${replace(local.resource_prefix, "-", "")}staticwebsite"
  resource_group_name           = local.resource_prefix
  location                      = local.azure_location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  min_tls_version               = "TLS1_2"
  https_traffic_only_enabled    = true
  public_network_access_enabled = true

  static_website {}

  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "OPTIONS"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 0
    }

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  sas_policy {
    expiration_period = "02.00:00:00"
  }

  tags = local.tags
}

resource "azapi_update_resource" "storage_key_rotation_reminder" {
  type        = "Microsoft.Storage/storageAccounts@2023-01-01"
  resource_id = azurerm_storage_account.storage.id
  body = jsonencode({
    properties = {
      keyPolicy : {
        keyExpirationPeriodInDays : 90
      }
    }
  })
}

resource "azurerm_storage_blob" "web" {
  for_each = fileset("${path.module}/wwwroot/", "**")

  name                   = each.value
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/wwwroot/${each.value}"
  content_md5            = filemd5("${path.module}/wwwroot/${each.value}")
  content_type           = lookup(local.content_types, element(split(".", each.value), length(split(".", each.value)) - 1), null)
  access_tier            = "Cool"
}

resource "azurerm_storage_blob" "index" {
  for_each = local.web_pages

  name                   = keys(each.value)[0]
  storage_account_name   = each.key
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = each.value[keys(each.value)[0]]
  content_type           = "text/html"
  access_tier            = "Cool"
}
