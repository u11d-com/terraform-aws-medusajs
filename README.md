# Terraform Module for MedusaJS on AWS

This Terraform module provides a flexible and scalable solution for deploying the [MedusaJS](https://medusajs.com/) e-commerce platform on Amazon Web Services (AWS). It allows users to create and manage all necessary infrastructure components, from basic deployments to more complex, customized configurations.

This module provides a complete set of composable sub-modules for each component of MedusaJS Infrastructure. These sub-modules can be used independently to deploy certain parts of infrastructure, but are combined inside the root module to deploy everything at once.

## Table of Contents

- [Features](#features)
- [Module Structure](#module-structure)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Conditional Resource Creation](#conditional-resource-creation)
- [Examples](#examples)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Modular Design:** The module is composed of sub-modules for each part of the infrastructure, providing a highly flexible and composable solution.
- **Comprehensive Resource Management:** Supports creation and management of essential MedusaJS infrastructure including VPC, subnets, ECR repositories, ElastiCache Redis, RDS PostgreSQL, backend, and storefront applications.
- **Customizable Configurations:** Allows for extensive customization of each component through a wide range of input variables.
- **Flexibility:** Supports both creating new infrastructure and integrating with existing AWS resources.
- **Ease of Use:** Provides sane defaults and clear examples for quick setup and deployment.
- **Scalable:** Designed to support both small and large-scale deployments of MedusaJS.

## Module Structure

This module is composed of the following sub-modules, each responsible for deploying specific resources. These sub-modules are also available as stand-alone modules and can be found in the `modules` directory.

-   [`backend`](/modules/backend): Creates resources for the MedusaJS backend application.
-   [`ecr`](/modules/ecr): Creates Elastic Container Registry (ECR) repositories for storing Docker images.
-   [`elasticache`](/modules/elasticache): Creates an ElastiCache Redis instance for MedusaJS backend (communication/cache).
-   [`rds`](/modules/rds): Creates an RDS PostgreSQL database instance for data persistence.
-   [`storefront`](/modules/storefront): Creates resources for the MedusaJS storefront application.
-   [`vpc`](/modules/vpc): Creates a Virtual Private Cloud (VPC) with necessary networking components.

## Usage

### Basic Usage

To use this module, include it in your Terraform configuration file, specifying the source and required variables. The following example shows the most basic usage:

```hcl
module "medusajs" {
  source = "u11d-com/terraform-u11d-medusajs"

  ## Required global variables (no defaults)
  project     = "my-project"
  environment = "example"

  ecr_storefront_create = true

  // Using example image build for MedusaJS starter
  backend_container_image = "ghcr.io/u11d-com/medusa-backend:1.20.10-latest"
  backend_seed_create = true
  backend_seed_run    = true
  backend_extra_environment_variables = {
    "NODE_ENV" : "development"
  }

  storefront_create          = false // Enable once image is built and pushed
  storefront_container_image = "xxx" // Full name of the image, including registry and tag
}
```

This example demonstrates how to use the root module to deploy MedusaJS with the most basic configuration. In the example:
  - project and environment variables are set to `my-project` and `example` respectively and will be used to fill resource tags.
  - ECR repository will be created for storefront, as `ecr_storefront_create` is set to `true`.
  - MedusaJS backend will be deployed using publicly available container image `ghcr.io/u11d-com/medusa-backend:1.20.10-latest` from GitHub container registry.
  - Database will be seeded after deployment by running seeding command, as `backend_seed_create` and `backend_seed_run` are set to `true`.
  - Example environment variable `NODE_ENV` is set to `development` value using `backend_extra_environment_variables` variable.
  - Storefront deployment is disabled, but can be enabled by setting `storefront_create` to `true` and passing proper image url using `storefront_container_image` variable.

## Conditional Resource Creation
The module allows for conditional creation of resources, providing a way to manage infrastructure and integrate with existing resources. To disable the creation of a specific resource, set its corresponding `*_create` variable to `false`. For example:

```hcl
module "medusajs" {
  source = "u11d-com/terraform-u11d-medusajs"

  ## Required global variables (no defaults)
  project     = "my-project"
  environment = "example"

  ## Conditional creation variables
  # Disable creation of ECR for backend in case you have external repository
  ecr_backend_create    = false
  # Disable creation of ECR for fronend in case you have external repository
  ecr_storefront_create = false
  # Disable creation of VPC for resources in case there is existing one
  vpc_create           = false
  # Disable creation of Redis instance for MedusaJS backend
  elasticache_create   = false
  # Disable creation of Postgresql RDS instance for MedusaJS backend
  rds_create          = false
  # Disable creation of MedusaJS backend resources
  backend_create      = false
  # Disable seed step for MedusaJS backend
  backend_seed_create = false
  # Disable creation of MedusaJS frontend resources
  storefront_create   = false
}
```

In this example, all resource creation is disabled and root module will deploy nothing, but still it provides a way to manage existing infrastructure.

## Examples

- [Minimal](/examples/minimal) - Minimal configuration needed for a basic deployment.
- [Complete](/examples/complete) - Complete example using all available variables, showcasing full configuration options.
- [External resources](/examples/external-resources) - Example using an existing VPC and external image repositories.

## Inputs
Detailed information about each input variable can be found in the module's documentation, or in the [variables.tf](/variables.tf) file in the root directory.

## Outputs
The module exposes a variety of outputs that allow users to access the deployed resources. These outputs are detailed in the [outputs.tf](/outputs.tf) file in the root directory.

## Troubleshooting
  - Check Terraform logs: If deployment fails, carefully inspect the logs output by Terraform.
  - Verify AWS credentials: Ensure your AWS CLI is configured correctly and has the required permissions.
  - Consult module documentation: For specific issues related to the u11d-com/terraform-u11d-medusajs module, refer to its documentation.
  - Seek community support: If you encounter issues you can not solve on your own, consider seeking help from the Terraform community or in the module's repository's issue tracker.

## Contact

If you have any questions, comments, or need assistance with this module, please feel free to reach out to us via email at [hello@u11d.com](mailto:hello@u11d.com). We are happy to help with any questions related to module usage or to resolve issues.

Additionally, if you require commercial development services for your MedusaJS platform, we offer expertise in building custom solutions, integrations, and more. Please contact us at the same email address to discuss your project needs.

## Contributing
We welcome contributions to this module! If you have bug fixes, new features, or documentation improvements, feel free to fork the repository, make your changes, and submit a pull request.

## License
This example is licensed under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0).


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.84.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ./modules/backend | n/a |
| <a name="module_ecr_backend"></a> [ecr\_backend](#module\_ecr\_backend) | ./modules/ecr | n/a |
| <a name="module_ecr_storefront"></a> [ecr\_storefront](#module\_ecr\_storefront) | ./modules/ecr | n/a |
| <a name="module_elasticache"></a> [elasticache](#module\_elasticache) | ./modules/elasticache | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./modules/rds | n/a |
| <a name="module_storefront"></a> [storefront](#module\_storefront) | ./modules/storefront | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of AZs to cover in a given region. | `number` | `2` | no |
| <a name="input_backend_admin_cors"></a> [backend\_admin\_cors](#input\_backend\_admin\_cors) | CORS configuration for the admin panel. If not provided, CORS will not be configured. | `string` | `null` | no |
| <a name="input_backend_admin_credentials"></a> [backend\_admin\_credentials](#input\_backend\_admin\_credentials) | Admin user credentials. If provided, it will be used to create an admin user. | <pre>object({<br/>    email             = string<br/>    password          = optional(string)<br/>    generate_password = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_backend_cloudfront_price_class"></a> [backend\_cloudfront\_price\_class](#input\_backend\_cloudfront\_price\_class) | The price class for the backend CloudFront distribution | `string` | `"PriceClass_100"` | no |
| <a name="input_backend_container_image"></a> [backend\_container\_image](#input\_backend\_container\_image) | Image tag of the docker image to run in the ECS cluster. | `string` | n/a | yes |
| <a name="input_backend_container_port"></a> [backend\_container\_port](#input\_backend\_container\_port) | Port exposed by the task container to redirect traffic to. | `number` | `9000` | no |
| <a name="input_backend_container_registry_credentials"></a> [backend\_container\_registry\_credentials](#input\_backend\_container\_registry\_credentials) | Credentials for private container registry authentication. Cannot be used together with backend\_ecr\_arn. | <pre>object({<br/>    username = string<br/>    password = string<br/>  })</pre> | `null` | no |
| <a name="input_backend_cookie_secret"></a> [backend\_cookie\_secret](#input\_backend\_cookie\_secret) | Secret used for cookie signing. If not provided, a random secret will be generated. | `string` | `null` | no |
| <a name="input_backend_create"></a> [backend\_create](#input\_backend\_create) | Enable backend resources creation | `bool` | `true` | no |
| <a name="input_backend_ecr_arn"></a> [backend\_ecr\_arn](#input\_backend\_ecr\_arn) | ARN of Elastic Container Registry. Cannot be used together with backend\_container\_registry\_credentials. | `string` | `null` | no |
| <a name="input_backend_expose_admin_only"></a> [backend\_expose\_admin\_only](#input\_backend\_expose\_admin\_only) | Whether to expose publicly only /admin paths in the backend | `bool` | `false` | no |
| <a name="input_backend_extra_environment_variables"></a> [backend\_extra\_environment\_variables](#input\_backend\_extra\_environment\_variables) | Additional environment variables to pass to the backend container | `map(string)` | `{}` | no |
| <a name="input_backend_extra_secrets"></a> [backend\_extra\_secrets](#input\_backend\_extra\_secrets) | Additional secrets to pass to the backend container | <pre>map(object({<br/>    arn = string<br/>    key = string<br/>  }))</pre> | `{}` | no |
| <a name="input_backend_extra_security_group_ids"></a> [backend\_extra\_security\_group\_ids](#input\_backend\_extra\_security\_group\_ids) | List of additional security group IDs to associate with the backend ECS service | `list(string)` | `[]` | no |
| <a name="input_backend_jwt_secret"></a> [backend\_jwt\_secret](#input\_backend\_jwt\_secret) | Secret used for JWT token signing. If not provided, a random secret will be generated. | `string` | `null` | no |
| <a name="input_backend_logs"></a> [backend\_logs](#input\_backend\_logs) | Logs configuration settings | <pre>object({<br/>    group     = string<br/>    retention = number<br/>    prefix    = string<br/>  })</pre> | <pre>{<br/>  "group": "/medusa-backend",<br/>  "prefix": "container",<br/>  "retention": 30<br/>}</pre> | no |
| <a name="input_backend_resources"></a> [backend\_resources](#input\_backend\_resources) | ECS Task configuration settings | <pre>object({<br/>    instances = number<br/>    cpu       = number<br/>    memory    = number<br/>  })</pre> | <pre>{<br/>  "cpu": 2048,<br/>  "instances": 1,<br/>  "memory": 4096<br/>}</pre> | no |
| <a name="input_backend_run_migrations"></a> [backend\_run\_migrations](#input\_backend\_run\_migrations) | Specify backend migrations should be run on start. | `bool` | `true` | no |
| <a name="input_backend_seed_command"></a> [backend\_seed\_command](#input\_backend\_seed\_command) | Command to run to seed the database. | `string` | `"npx medusa seed -f ./data/seed.json"` | no |
| <a name="input_backend_seed_create"></a> [backend\_seed\_create](#input\_backend\_seed\_create) | Enable backend seed function creation | `bool` | `false` | no |
| <a name="input_backend_seed_fail_on_error"></a> [backend\_seed\_fail\_on\_error](#input\_backend\_seed\_fail\_on\_error) | Whether to fail the deployment if the seed command fails. | `bool` | `true` | no |
| <a name="input_backend_seed_run"></a> [backend\_seed\_run](#input\_backend\_seed\_run) | Specify backend seed should be run after deployment. | `bool` | `false` | no |
| <a name="input_backend_seed_timeout"></a> [backend\_seed\_timeout](#input\_backend\_seed\_timeout) | Timeout for the seed command. | `number` | `60` | no |
| <a name="input_backend_store_cors"></a> [backend\_store\_cors](#input\_backend\_store\_cors) | CORS configuration for the store. If not provided, CORS will not be configured. | `string` | `null` | no |
| <a name="input_backend_target_group_health_check_config"></a> [backend\_target\_group\_health\_check\_config](#input\_backend\_target\_group\_health\_check\_config) | Health check configuration for load balancer target group pointing on backend containers | <pre>object({<br/>    interval            = number<br/>    matcher             = number<br/>    timeout             = number<br/>    path                = string<br/>    healthy_threshold   = number<br/>    unhealthy_threshold = number<br/>  })</pre> | <pre>{<br/>  "healthy_threshold": 3,<br/>  "interval": 30,<br/>  "matcher": 200,<br/>  "path": "/health",<br/>  "timeout": 3,<br/>  "unhealthy_threshold": 3<br/>}</pre> | no |
| <a name="input_backend_url"></a> [backend\_url](#input\_backend\_url) | Medusa backend URL. Required if backend\_create is false. | `string` | `null` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block used in VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_database_url"></a> [database\_url](#input\_database\_url) | Database connection URL. Required if rds\_create is false. | `string` | `null` | no |
| <a name="input_ecr_backend_create"></a> [ecr\_backend\_create](#input\_ecr\_backend\_create) | Enable backend ECR repository creation | `bool` | `false` | no |
| <a name="input_ecr_backend_retention_count"></a> [ecr\_backend\_retention\_count](#input\_ecr\_backend\_retention\_count) | How many images to keep in backend repository | `number` | `32` | no |
| <a name="input_ecr_storefront_create"></a> [ecr\_storefront\_create](#input\_ecr\_storefront\_create) | Enable storefront ECR repository creation | `bool` | `false` | no |
| <a name="input_ecr_storefront_retention_count"></a> [ecr\_storefront\_retention\_count](#input\_ecr\_storefront\_retention\_count) | How many images to keep in storefront repository | `number` | `32` | no |
| <a name="input_elasticache_create"></a> [elasticache\_create](#input\_elasticache\_create) | n/a | `bool` | `true` | no |
| <a name="input_elasticache_node_type"></a> [elasticache\_node\_type](#input\_elasticache\_node\_type) | The Elasticache instance class used. | `string` | `"cache.t3.micro"` | no |
| <a name="input_elasticache_nodes_num"></a> [elasticache\_nodes\_num](#input\_elasticache\_nodes\_num) | The initial number of cache nodes that the cache cluster will have. | `number` | `1` | no |
| <a name="input_elasticache_port"></a> [elasticache\_port](#input\_elasticache\_port) | Port exposed by the redis to redirect traffic to. | `number` | `6379` | no |
| <a name="input_elasticache_redis_engine_version"></a> [elasticache\_redis\_engine\_version](#input\_elasticache\_redis\_engine\_version) | The version of the redis that will be used to create the Elasticache cluster. You can provide a prefix of the version such as 7.1 (for 7.1.4). | `string` | `"7.1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment for which infrastructure is being provisioned. | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs. Required if vpc\_create is false. | `list(string)` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The name of the project for which infrastructure is being provisioned. | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs. Required if vpc\_create is false. | `list(string)` | `null` | no |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | The allocated storage in gigabytes. | `number` | `5` | no |
| <a name="input_rds_create"></a> [rds\_create](#input\_rds\_create) | n/a | `bool` | `true` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | The postgres engine version to use. You can provide a prefix of the version such as 8.0 (for 8.0.36). | `string` | `"15.7"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | The instance type of the RDS instance. | `string` | `"db.t3.micro"` | no |
| <a name="input_rds_port"></a> [rds\_port](#input\_rds\_port) | Port exposed by the RDS. | `number` | `5432` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | The username used to authenticate with the PostgreSQL database. | `string` | `"medusa"` | no |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | Redis connection URL. Required if elasticache\_create is false. | `string` | `null` | no |
| <a name="input_storefront_cloudfront_price_class"></a> [storefront\_cloudfront\_price\_class](#input\_storefront\_cloudfront\_price\_class) | The price class for the CloudFront distribution | `string` | `"PriceClass_100"` | no |
| <a name="input_storefront_container_image"></a> [storefront\_container\_image](#input\_storefront\_container\_image) | Image tag of the docker image to run in the ECS cluster. | `string` | n/a | yes |
| <a name="input_storefront_container_port"></a> [storefront\_container\_port](#input\_storefront\_container\_port) | Port exposed by the task container to redirect traffic to. | `number` | `8000` | no |
| <a name="input_storefront_container_registry_credentials"></a> [storefront\_container\_registry\_credentials](#input\_storefront\_container\_registry\_credentials) | Credentials for private container registry authentication. Cannot be used together with storefront\_ecr\_arn. | <pre>object({<br/>    username = string<br/>    password = string<br/>  })</pre> | `null` | no |
| <a name="input_storefront_create"></a> [storefront\_create](#input\_storefront\_create) | Enable storefront resources creation | `bool` | `false` | no |
| <a name="input_storefront_ecr_arn"></a> [storefront\_ecr\_arn](#input\_storefront\_ecr\_arn) | ARN of Elastic Container Registry. Cannot be used together with storefront\_container\_registry\_credentials. | `string` | `null` | no |
| <a name="input_storefront_extra_environment_variables"></a> [storefront\_extra\_environment\_variables](#input\_storefront\_extra\_environment\_variables) | Additional environment variables to pass to the storefront container | `map(string)` | `{}` | no |
| <a name="input_storefront_extra_secrets"></a> [storefront\_extra\_secrets](#input\_storefront\_extra\_secrets) | Additional secrets to pass to the storefront container | <pre>map(object({<br/>    arn = string<br/>    key = string<br/>  }))</pre> | `{}` | no |
| <a name="input_storefront_extra_security_group_ids"></a> [storefront\_extra\_security\_group\_ids](#input\_storefront\_extra\_security\_group\_ids) | List of additional security group IDs to associate with the storefront ECS service | `list(string)` | `[]` | no |
| <a name="input_storefront_logs"></a> [storefront\_logs](#input\_storefront\_logs) | Logs configuration settings | <pre>object({<br/>    group     = string<br/>    retention = number<br/>    prefix    = string<br/>  })</pre> | <pre>{<br/>  "group": "/medusa-storefront",<br/>  "prefix": "container",<br/>  "retention": 30<br/>}</pre> | no |
| <a name="input_storefront_resources"></a> [storefront\_resources](#input\_storefront\_resources) | ECS Task configuration settings | <pre>object({<br/>    instances = number<br/>    cpu       = number<br/>    memory    = number<br/>  })</pre> | <pre>{<br/>  "cpu": 1024,<br/>  "instances": 1,<br/>  "memory": 2048<br/>}</pre> | no |
| <a name="input_storefront_target_group_health_check_config"></a> [storefront\_target\_group\_health\_check\_config](#input\_storefront\_target\_group\_health\_check\_config) | Health check configuration for load balancer target group pointing on storefront containers | <pre>object({<br/>    interval            = number<br/>    matcher             = number<br/>    timeout             = number<br/>    path                = string<br/>    healthy_threshold   = number<br/>    unhealthy_threshold = number<br/>  })</pre> | <pre>{<br/>  "healthy_threshold": 3,<br/>  "interval": 30,<br/>  "matcher": 200,<br/>  "path": "/api",<br/>  "timeout": 3,<br/>  "unhealthy_threshold": 3<br/>}</pre> | no |
| <a name="input_vpc_create"></a> [vpc\_create](#input\_vpc\_create) | Enable vpc creation | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Existing VPC ID. Required if vpc\_create is false. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | n/a |
| <a name="output_ecr_backend_url"></a> [ecr\_backend\_url](#output\_ecr\_backend\_url) | n/a |
| <a name="output_ecr_storefront_url"></a> [ecr\_storefront\_url](#output\_ecr\_storefront\_url) | n/a |
| <a name="output_storefront_url"></a> [storefront\_url](#output\_storefront\_url) | n/a |
<!-- END_TF_DOCS -->

---
:heart: _Technology made with passion by u11d_