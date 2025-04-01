<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.93.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.93.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [archive_file.seed](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/resources/file) | resource |
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.block_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_vpc_origin.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_access_key.medusa_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.medusa_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_lambda_function.seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.seed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_s3_bucket.uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_cors_configuration.uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_policy.allow_public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_secretsmanager_secret.admin_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.cookie_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.jwt_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.registry_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.s3_user_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.admin_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.cookie_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.jwt_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.registry_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.s3_user_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.vpc_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [null_resource.lambda_seed_source_hash_changed](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.cookie_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.jwt_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ec2_managed_prefix_list.vpc_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_policy_document.allow_public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_execution_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_seed_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_seed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of the ACM certificate to use for the CloudFront distribution | `string` | `null` | no |
| <a name="input_admin_cors"></a> [admin\_cors](#input\_admin\_cors) | CORS configuration for the admin panel | `string` | n/a | yes |
| <a name="input_admin_credentials"></a> [admin\_credentials](#input\_admin\_credentials) | Admin user credentials. If provided, it will be used to create an admin user. | <pre>object({<br/>    email             = string<br/>    password          = optional(string)<br/>    generate_password = optional(bool, true)<br/>  })</pre> | n/a | yes |
| <a name="input_cloudfront_price_class"></a> [cloudfront\_price\_class](#input\_cloudfront\_price\_class) | The price class for the CloudFront distribution | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | n/a | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port exposed by the task container to redirect traffic to. | `number` | n/a | yes |
| <a name="input_container_registry_credentials"></a> [container\_registry\_credentials](#input\_container\_registry\_credentials) | Credentials for private container registry authentication | <pre>object({<br/>    username = string<br/>    password = string<br/>  })</pre> | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Project context containing project name and environment | <pre>object({<br/>    project     = string<br/>    environment = string<br/>    Owner       = string<br/>    ManagedBy   = string<br/>  })</pre> | n/a | yes |
| <a name="input_cookie_secret"></a> [cookie\_secret](#input\_cookie\_secret) | Secret used for cookie signing. If not provided, a random secret will be generated. | `string` | n/a | yes |
| <a name="input_custom_domains"></a> [custom\_domains](#input\_custom\_domains) | List of custom domains to use for the CloudFront distribution | `list(string)` | `null` | no |
| <a name="input_database_url"></a> [database\_url](#input\_database\_url) | URL for database connection | `string` | n/a | yes |
| <a name="input_deployment_circuit_breaker"></a> [deployment\_circuit\_breaker](#input\_deployment\_circuit\_breaker) | Deployment circuit breaker configuration | <pre>object({<br/>    enable   = bool<br/>    rollback = bool<br/>  })</pre> | `null` | no |
| <a name="input_ecr_arn"></a> [ecr\_arn](#input\_ecr\_arn) | ARN of Elastic Container Registry. | `string` | n/a | yes |
| <a name="input_ecs_container_insights"></a> [ecs\_container\_insights](#input\_ecs\_container\_insights) | Enable container insights for the ECS cluster | `string` | `"disabled"` | no |
| <a name="input_expose_admin_only"></a> [expose\_admin\_only](#input\_expose\_admin\_only) | Whether to expose only /admin paths | `bool` | n/a | yes |
| <a name="input_extra_environment_variables"></a> [extra\_environment\_variables](#input\_extra\_environment\_variables) | Additional environment variables to pass to the container | `map(string)` | n/a | yes |
| <a name="input_extra_secrets"></a> [extra\_secrets](#input\_extra\_secrets) | Additional secrets to pass to the container | <pre>map(object({<br/>    arn = string<br/>    key = string<br/>  }))</pre> | n/a | yes |
| <a name="input_extra_security_group_ids"></a> [extra\_security\_group\_ids](#input\_extra\_security\_group\_ids) | List of additional security group IDs to associate with the ECS service | `list(string)` | n/a | yes |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | The grace period for health checks in seconds | `number` | `null` | no |
| <a name="input_jwt_secret"></a> [jwt\_secret](#input\_jwt\_secret) | Secret used for JWT token signing. If not provided, a random secret will be generated. | `string` | n/a | yes |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of load balancer to create (application or network) | `string` | `"application"` | no |
| <a name="input_logs"></a> [logs](#input\_logs) | Logs configuration settings | <pre>object({<br/>    group     = string<br/>    retention = number<br/>    prefix    = string<br/>  })</pre> | n/a | yes |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | URL for Redis connection | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | ECS Task configuration settings | <pre>object({<br/>    instances = number<br/>    cpu       = number<br/>    memory    = number<br/>  })</pre> | n/a | yes |
| <a name="input_run_migrations"></a> [run\_migrations](#input\_run\_migrations) | Specify medusa migrations should be run on start. | `bool` | n/a | yes |
| <a name="input_seed_command"></a> [seed\_command](#input\_seed\_command) | Command to run for seeding the database | `string` | n/a | yes |
| <a name="input_seed_create"></a> [seed\_create](#input\_seed\_create) | Whether to create infrastructure for seeding the database | `bool` | n/a | yes |
| <a name="input_seed_fail_on_error"></a> [seed\_fail\_on\_error](#input\_seed\_fail\_on\_error) | Whether to fail the deployment if the seed command fails | `bool` | n/a | yes |
| <a name="input_seed_run"></a> [seed\_run](#input\_seed\_run) | Whether to run the seed command after deployment | `bool` | n/a | yes |
| <a name="input_seed_timeout"></a> [seed\_timeout](#input\_seed\_timeout) | Timeout for the seed command | `number` | n/a | yes |
| <a name="input_store_cors"></a> [store\_cors](#input\_store\_cors) | CORS configuration for the store | `string` | n/a | yes |
| <a name="input_target_group_health_check_config"></a> [target\_group\_health\_check\_config](#input\_target\_group\_health\_check\_config) | Health check configuration for load balancer target group pointing on backend containers | <pre>object({<br/>    interval            = number<br/>    matcher             = number<br/>    timeout             = number<br/>    path                = string<br/>    healthy_threshold   = number<br/>    unhealthy_threshold = number<br/>  })</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configuration object containing VPC ID and subnet IDs | <pre>object({<br/>    id                 = string<br/>    public_subnet_ids  = list(string)<br/>    private_subnet_ids = list(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_secret_arn"></a> [admin\_secret\_arn](#output\_admin\_secret\_arn) | n/a |
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->
