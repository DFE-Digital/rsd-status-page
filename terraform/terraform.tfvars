azure_subscription_id = "e8bc9314-d27f-403a-bbe0-6b189d2efad2"
azure_tenant_id       = "9c7d9dd3-840c-4b3f-818e-552865082e16"

environment    = "s184p01-"
project_name   = "rsd-status-page"
azure_location = "westeurope"

function_apps = {
  "Apply to Become" : {
    name : "s184p01-a2bext-health-api"
    resource_group_name : "s184p01-a2bext"
  }
  "Find Information about Academies and Trusts" : {
    name : "s184p01-fiat-health-api"
    resource_group_name : "s184p01-fiat"
  }
  "Record Concerns and Support Trusts" : {
    name : "s184p01-amsd-health-api"
    resource_group_name : "s184p01-amsd"
  }
  "Manage Free School Projects" : {
    name : "s184p01-mfsp-health-api"
    resource_group_name : "s184p01-mfsp"
  }
  "Complete Conversions Transfers and Changes (Ruby)" : {
    name : "s184p01-comp-health-api"
    resource_group_name : "s184p01-comp"
  }
  "Complete Conversions Transfers and Changes (.NET)" : {
    name : "s184p01-compdotnet-health-api"
    resource_group_name : "s184p01-comp"
  }
  "Academies API" : {
    name : "s184p01-tramsapi-health-api"
    resource_group_name : "s184p01-tramsapi"
  }
  "Persons API" : {
    name : "s184p01-prsnsapi-health-api"
    resource_group_name : "s184p01-tramsapi"
  }
  "Manage School Improvements" : {
    name : "s184p01-rise-health-api"
    resource_group_name : "s184p01-rise"
  }
  "Academisation API" : {
    name : "s184p01-aca-health-api"
    resource_group_name : "s184p01-aca"
  }
  "Prepare Conversions and Transfers" : {
    name : "s184p01-a2bint-health-api"
    resource_group_name : "s184p01-a2bint"
  }
}

tags = {
  "Environment"      = "Prod"
  "Product"          = "SIP - Academies and Free Schools Systems Integration Programme"
  "Service Offering" = "SIP - Academies and Free Schools Systems Integration Programme"
  "GitHub"           = "rsd-status-page"
  "Service Name"     = "RSD Status Page"
}
