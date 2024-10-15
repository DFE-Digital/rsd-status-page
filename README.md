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

There is a Terraform variable called 'function_apps' which is populated in the
`terraform.tfvars` file.

Simply add the name and resource group of an existing Function App* keyed by a
label and Terraform will attempt to locate and generate a secure url, and add it
to the 'app.js' file.

*Function Apps must exist in the same Tenant / Subscription as the authenticated
Terraform user

## Build

There aren't any build requirements. Keep it simple.
