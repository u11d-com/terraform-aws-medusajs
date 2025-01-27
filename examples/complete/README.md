# Complete example using all available variables

## Usage
Provide 
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example may create resources which cost money. Run terraform destroy when you don't need these resources.

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
| <a name="module_complete"></a> [complete](#module\_complete) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | n/a |
| <a name="output_ecr_backend_url"></a> [ecr\_backend\_url](#output\_ecr\_backend\_url) | n/a |
| <a name="output_ecr_storefront_url"></a> [ecr\_storefront\_url](#output\_ecr\_storefront\_url) | n/a |
| <a name="output_storefront_url"></a> [storefront\_url](#output\_storefront\_url) | n/a |
<!-- END_TF_DOCS -->
