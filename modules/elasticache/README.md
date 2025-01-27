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
| [aws_elasticache_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | Project context containing project name and environment | <pre>object({<br/>    project     = string<br/>    environment = string<br/>  })</pre> | n/a | yes |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The Elasticache instance class used. | `string` | n/a | yes |
| <a name="input_nodes_num"></a> [nodes\_num](#input\_nodes\_num) | The initial number of cache nodes that the cache cluster will have. | `number` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Port exposed by the redis to redirect traffic to. | `number` | n/a | yes |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | The version of the redis that will be used to create the Elasticache cluster. You can provide a prefix of the version such as 7.1 (for 7.1.4). | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configuration object containing VPC ID and subnet IDs | <pre>object({<br/>    id                 = string<br/>    public_subnet_ids  = list(string)<br/>    private_subnet_ids = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_security_group_id"></a> [client\_security\_group\_id](#output\_client\_security\_group\_id) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->
