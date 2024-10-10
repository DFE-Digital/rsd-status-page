# RSD Status Page

This repository is responsible for deploying the HTML Static Website that serves
as a status page widget for all services deployed in CIP Production environment.

The intention is that this page will be embedded into SharePoint.

## Infrastructure

Azure infrastructure is deployed into the 's184-RSD-Production' subscription only.

## Contributing

- If you want to change any of the web assets you can modify files in 'wwwroot'.
- If you want to change any infrastructure, modify files in 'terraform'.

## Modifying API calls

There is a Terraform variable called 'endpoints' which is populated by a GitHub
secret called 'TF_TARGET_ENDPOINTS'.

Populate the secret as a JSON string like such:

```json
{
  "My-Azure-Function"                              = "https://xxx.azurewebsites.net/api/http_trigger?code=xxx"
}
```

## Build

There aren't any build requirements. Keep it simple.
