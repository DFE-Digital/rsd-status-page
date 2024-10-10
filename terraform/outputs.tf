output "web_page_storage_accounts" {
  value       = azurerm_storage_account.storage.primary_web_endpoint
  description = "Storage Accounts used for holding web assets"
}
