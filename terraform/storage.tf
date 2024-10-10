resource "azurerm_storage_account" "storage" {
  name                          = replace(local.resource_prefix, "-", "")
  resource_group_name           = local.resource_group.name
  location                      = local.resource_group.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  min_tls_version               = "TLS1_2"
  https_traffic_only_enabled    = true
  public_network_access_enabled = true

  static_website {
    index_document = "index.html"
  }

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
  for_each = toset(local.allowed_files)

  name                   = each.value
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${local.root_path}/wwwroot/${each.value}"
  content_md5            = filemd5("${local.root_path}/wwwroot/${each.value}")
  content_type           = lookup(local.content_types, element(split(".", each.value), length(split(".", each.value)) - 1), null)
  access_tier            = "Cool"
}

resource "azurerm_storage_blob" "templates" {
  for_each = local.templates

  name                   = each.key == "index.html.tftpl" ? "index.html" : each.key
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = each.value
  content_md5            = md5(each.value)
  content_type           = "text/html"
  access_tier            = "Cool"

  depends_on = [azurerm_storage_blob.web]
}
