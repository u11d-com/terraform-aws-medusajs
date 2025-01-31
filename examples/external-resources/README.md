# MedusaJS Infrastructure on AWS with External Resources: Existing VPC and External Image Repository

This Terraform configuration deploys a MedusaJS e-commerce platform infrastructure on AWS using the publicly available [`u11d-com/terraform-aws-medusajs`](https://github.com/u11d-com/terraform-aws-medusajs) module, utilizing **existing** VPC and external container registries. In addition to that, it also deploys ElastiCache Redis and RDS PostgreSQL databases as part of its infrastructure. This example demonstrates how to integrate your existing AWS infrastructure with the MedusaJS deployment and includes essential database components.

## Table of Contents

- [Features](#features)
- [Deployment Strategy](#deployment-strategy)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Deployment](#deployment)
  - [Outputs](#outputs)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- Deploys a MedusaJS backend and storefront infrastructure.
- Uses **existing** AWS VPC and subnets.
- Uses Docker images from **external** container registries.
- Does not create new ECR repositories, instead uses the provided registry images.
- Supports authentication for private external registries.
- Deploys ElastiCache Redis for caching.
- Deploys RDS PostgreSQL for data persistence.
- Provides outputs for accessing the deployed resources.
- Configurable using Terraform variables.

## Deployment Strategy

MedusaJS starter kits typically use the Next.js framework to build the storefront web application. Next.js requires that the MedusaJS backend is available and responsive during the build process to properly fetch data and create a fully functional storefront. This is important because the storefront will be built using the API provided by the backend application.

This module is designed to integrate with *existing* infrastructure and uses *external* container registries for your MedusaJS storefront image. The typical deployment process involves the following steps:

1. **Deploy the MedusaJS backend:** First, you must deploy the backend infrastructure using this Terraform module. Obtain the backend URL from the module's output.
2.  **Build and push the storefront image:** Build your Next.js storefront application, pointing it to the deployed backend URL from step 1. Then, either build a Docker image of your storefront and push it to your *external* container registry, *or use a pre-built storefront image and proceed to step 3*.
3.  **Deploy the storefront:** Finally, you can configure this module to deploy storefront from the image stored in your *external* registry, by setting `storefront_create` option to true and providing proper image path, including the tag, using `storefront_container_image` variable, as well as providing registry credentials. If you already have a prebuilt storefront application as a Docker image, you can use this module to deploy it from your *external* registry, by providing the `storefront_container_image` variable with the full image path, including the tag, and relevant registry credentials.

While this module primarily focuses on backend deployment, it also supports storefront deployment as mentioned in step 3.

## Prerequisites

Before you begin, make sure you have the following:

- **Terraform:** Version `~> 1.9` or higher installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- **AWS Account:** An active AWS account with appropriate permissions to create resources.
- **AWS CLI:** The AWS Command Line Interface configured with your credentials. You can find instructions on how to install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Basic understanding of Terraform:** Familiarity with basic Terraform concepts like providers, modules, and outputs.
- **Docker:** (Optional) If you plan to create custom Docker images for MedusaJS. Install from [official Docker website](https://docs.docker.com/engine/install/).
- **Existing AWS VPC:** You must have an existing VPC with available public and private subnets. You'll need to provide the IDs of these resources.
- **External Container Registry:** You must have access to a container registry that hosts your MedusaJS backend and storefront containers images. You'll need the registry URL, username, and password if authentication is required.

## Usage

### Configuration

1. Clone this repository: [terraform-aws-medusajs](https://github.com/u11d-com/terraform-aws-medusajs)
    ```bash
    git clone https://github.com/u11d-com/terraform-aws-medusajs.git
    cd terraform-aws-medusajs/examples/external-resources
    ```

<details>

<summary>2. Review the <code>main.tf</code> file (click to expand)</summary>

This file contains the Terraform configuration for deploying the MedusaJS infrastructure.
  - terraform block: Specifies the required Terraform version.
  - locals block: Defines local variables for project and environment names. You can customize these.
  - provider "aws" block: Configures the AWS provider and sets default tags for all resources. Change the region to match your desired location.
  - module "external_resources" block: This is the core of the setup. It uses the `u11d-com/terraform-aws-medusajs` module to create your infrastructure with external resources. Here's a breakdown of the key parameters:
    - source: The location of the Terraform module.
    - project and environment: These parameters are passed to the module and may be used to tag the AWS resources or other logic inside the module
    - vpc_create: Set to `false` to indicate usage of an existing VPC.
    - vpc_id: ID of the existing VPC.
    - public_subnet_ids: A list of IDs of the public subnets in your VPC.
    - private_subnet_ids: A list of IDs of the private subnets in your VPC.
    - ecr_backend_create: Set to `false` to prevent the creation of backend ECR repository.
    - ecr_storefront_create: Set to `false` to prevent the creation of storefront ECR repository.
    - backend_create: Specifies if to deploy backend application
    - backend_container_image: Specifies the Docker image URL for the MedusaJS backend.
    - backend_container_registry_credentials:  Credentials to access the external backend registry.
    - storefront_create: Specifies if to deploy storefront application.
    - storefront_container_image: Specifies the Docker image URL for the MedusaJS storefront.
    - storefront_container_registry_credentials:  Credentials to access the external storefront registry.
    - elasticache_create: Specifies if to create ElastiCache Redis cluster.
    - rds_create: Specifies if to create RDS PostgreSQL database.
  - output blocks: Define values that will be displayed after deployment.
</details>

### Deployment

1.  Initialize Terraform:
    ```bash
    terraform init
    ```
    This command will download the necessary providers and modules.
2.  (Optional) Create a Terraform [workspace](https://developer.hashicorp.com/terraform/cli/workspaces): To keep environments separated, you can create a workspace for your deployment. Example for `medusa-external` workspace is:
    ```bash
    terraform workspace new medusa-external
    terraform workspace select medusa-external
    ```
3.  Plan the deployment:
    ```bash
    terraform plan
    ```
    This command will show you what resources Terraform will create, modify, or destroy. Review the plan carefully.
4.  Apply the deployment:
    ```bash
    terraform apply
    ```
    Terraform will prompt you to confirm the changes. Type `yes` to proceed with the deployment.
    This will deploy the defined infrastructure on AWS. It may take some time to complete.

### Outputs

After successful deployment, Terraform will display output values. These include:
- `backend_url`: The URL of the deployed backend application.
- `storefront_url`: The URL of the deployed storefront application.

## Customization

- Adjust the `locals` block: Modify the project and environment variables to suit your needs.
- Change the AWS `region`: Modify the region value within the provider "aws" block.
- Customize the module parameters: Explore the documentation for the `u11d-com/terraform-aws-medusajs` module to understand all possible customization options. You can find the documentation in the module's repository or in the Terraform Registry.
- **Use existing VPC:** Make sure that `vpc_create` is set to `false` and provide correct `vpc_id`, `public_subnet_ids`, and `private_subnet_ids` values.
- **Use external container registries:** Provide valid container image URLs, `backend_container_image` and `storefront_container_image` , and credentials if needed,  `backend_container_registry_credentials` and `storefront_container_registry_credentials`.
- Configure additional environment variables: Add more environment variables to `backend_extra_environment_variables` to configure your MedusaJS application.

## Troubleshooting

- Check Terraform logs: If deployment fails, carefully inspect the logs output by Terraform.
- Verify AWS credentials: Ensure your AWS CLI is configured correctly and has the required permissions.
- Verify VPC and subnet settings: Ensure the provided VPC and subnet IDs are correct and that the subnets have the required configurations.
- Verify External registry credentials: Ensure that external registry credentials are correct and user has proper permissions to access images.
- Seek community support: If you encounter issues you can not solve on your own, consider seeking help from the Terraform community or in the module's repository's issue tracker.
- :email: [Contact us](mailto:hello@u11d.com) for support or development.

## Contributing

Feel free to contribute to this example or the `u11d-com/terraform-aws-medusajs` module. Bug fixes, new features, and documentation improvements are welcome. Fork the repository, make your changes, and submit a pull request.

## License

This example is licensed under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0).



## Usage
You need to deploy backend first, then build frontend application based on the outputs of the module and provide container repository url with tag.

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