<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.84.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | Project context containing project name and environment | <pre>object({<br/>    project     = string<br/>    environment = string<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECR repository | `string` | n/a | yes |
| <a name="input_retention_count"></a> [retention\_count](#input\_retention\_count) | How many images to keep in repository | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ECR repository ARN |
| <a name="output_url"></a> [url](#output\_url) | ECR repository URL |
<!-- END_TF_DOCS -->
