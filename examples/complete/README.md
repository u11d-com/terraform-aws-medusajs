# Complete example using all available variables

## Usage
You need to deploy backend first, then build frontend application based on the outputs of the module and provide container repository url with tag.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | u11d-com/terraform-u11d-medusajs | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | The URL of the backend application. Only available when backend\_create is true. |
| <a name="output_ecr_backend_url"></a> [ecr\_backend\_url](#output\_ecr\_backend\_url) | The URL of the backend ECR repository. Only available when ecr\_backend\_create is true. |
| <a name="output_ecr_storefront_url"></a> [ecr\_storefront\_url](#output\_ecr\_storefront\_url) | The URL of the storefront ECR repository. Only available when ecr\_storefront\_create is true. |
| <a name="output_storefront_url"></a> [storefront\_url](#output\_storefront\_url) | The URL of the storefront application. Only available when storefront\_create is true. |
<!-- END_TF_DOCS -->
