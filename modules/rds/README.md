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
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_secretsmanager_secret.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes. | `number` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Project context containing project name and environment | <pre>object({<br/>    project     = string<br/>    environment = string<br/>  })</pre> | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The postgres engine version to use. You can provide a prefix of the version such as 8.0 (for 8.0.36). | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections. | `number` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | The username used to authenticate with the PostgreSQL database. | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configuration object containing VPC ID and subnet IDs | <pre>object({<br/>    id                 = string<br/>    public_subnet_ids  = list(string)<br/>    private_subnet_ids = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_security_group_id"></a> [client\_security\_group\_id](#output\_client\_security\_group\_id) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->
