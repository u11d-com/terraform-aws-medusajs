# MedusaJS Complete Infrastructure on AWS with Terraform

This Terraform configuration deploys a complete MedusaJS e-commerce platform infrastructure on AWS using the publicly available [`u11d-com/terraform-aws-medusajs`](https://github.com/u11d-com/terraform-aws-medusajs) module, demonstrating the usage of *all available variables and options.* This example is designed to showcase the full spectrum of customization and configuration capabilities offered by the module, providing a robust and feature-rich deployment.

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

- Deploys a complete MedusaJS backend and storefront infrastructure.
- Creates new Elastic Container Registry (ECR) repositories for backend and storefront images.
- Creates a new Virtual Private Cloud (VPC) with specified CIDR and Availability Zones.
- Deploys ElastiCache Redis for caching with customizable node type and engine version.
- Deploys RDS PostgreSQL for data persistence with customizable instance class and engine version.
- Configures health checks for backend and storefront applications.
- Uses CloudFront for CDN capabilities with configurable price class.
- Provides options to configure backend migrations, seeding, and resources.
- Allows customization of container ports, environment variables, secrets, and security groups.
- Creates detailed CloudWatch logs for backend and storefront.
- Provides outputs for accessing the deployed resources.
- Configurable using Terraform variables.

## Deployment Strategy

MedusaJS starter kits typically use the Next.js framework to build the storefront web application. Next.js requires that the MedusaJS backend is available and responsive during the build process to properly fetch data and create a fully functional storefront. This is important because storefront will be built with the API provided by backend application.

Therefore, the deployment process can be divided into two main steps:

1. **Deploy the MedusaJS backend:** First, you must deploy the backend infrastructure using this Terraform module. Obtain the backend URL from the module's output.
2. **Build and Deploy the storefront:** After the backend is deployed and running, you can proceed to build your Next.js storefront application, pointing it to deployed backend URL from step 1. Once storefront application is built, deploy it to the infrastructure of your choice. If you already have prebuilt storefront application as a Docker image, you can use this module to deploy it, by providing `storefront_container_image` value.

This module focuses on the backend deployment but can deploy storefront if `storefront_create` option is set to true and proper `storefront_container_image` is provided.

## Prerequisites

Before you begin, make sure you have the following:

- **Terraform:** Version `~> 1.9` or higher installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- **AWS Account:** An active AWS account with appropriate permissions to create resources.
- **AWS CLI:** The AWS Command Line Interface configured with your credentials. You can find instructions on how to install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Basic understanding of Terraform:** Familiarity with basic Terraform concepts like providers, modules, and outputs.
- **Docker:** (Optional) If you plan to create custom Docker images for MedusaJS. Install from [official Docker website](https://docs.docker.com/engine/install/).
- **Custom MedusaJS Docker Images:**  You should have Docker images prepared for both the MedusaJS backend and storefront and have their URLs ready.

## Usage

### Configuration

1.  Clone this repository: [terraform-aws-medusajs](https://github.com/u11d-com/terraform-aws-medusajs)
    ```bash
    git clone https://github.com/u11d-com/terraform-aws-medusajs.git
    cd terraform-aws-medusajs/examples/complete
    ```

<details>

<summary>2. Review the <code>main.tf</code> file (click to expand)</summary>

This file contains the Terraform configuration for deploying the complete MedusaJS infrastructure.
  - `terraform` block: Specifies the required Terraform version.
  - `locals` block: Defines local variables for project and environment names. You can customize these.
  - `provider "aws"` block: Configures the AWS provider and sets default tags for all resources. Change the region to match your desired location.
  - `module "complete"` block: This is the core of the setup. It uses the `u11d-com/terraform-aws-medusajs` module to create a complete infrastructure, using all available parameters. Here's a breakdown of the key parameter categories:
  - **Global Settings:**
    - `project` and `environment`: These parameters are passed to the module and may be used to tag the AWS resources or other logic inside the module
  - **ECR Configuration:**
    - `ecr_backend_create`: Set to `true` to create a backend ECR repository.
    - `ecr_backend_retention_count`: Sets the number of images to retain in the backend ECR repository.
    - `ecr_storefront_create`: Set to `true` to create a storefront ECR repository.
    - `ecr_storefront_retention_count`: Sets the number of images to retain in the storefront ECR repository.
  - **Network Configuration:**
    - `vpc_create`: Set to `true` to create a new VPC.
    - `cidr_block`: CIDR block for the new VPC.
    - `az_count`: The number of Availability Zones to use for the VPC.
  - **ElastiCache Configuration:**
    - `elasticache_create`: Set to `true` to create an ElastiCache Redis cluster.
    - `elasticache_node_type`: The node type for the ElastiCache Redis cluster.
    - `elasticache_nodes_num`: The number of nodes for the ElastiCache Redis cluster.
    - `elasticache_redis_engine_version`: The Redis engine version to use.
    - `elasticache_port`: The port to be used for Redis cluster.
  - **RDS Configuration:**
    - `rds_create`: Set to `true` to create an RDS PostgreSQL instance.
    - `rds_username`: The username for the RDS PostgreSQL database.
    - `rds_instance_class`: The instance class for the RDS PostgreSQL instance.
    - `rds_allocated_storage`: The allocated storage (in GB) for the RDS PostgreSQL instance.
    - `rds_engine_version`: The PostgreSQL engine version.
    - `rds_port`: The port to be used for RDS PostgreSQL.
  - **Backend Configuration:**
    - `backend_create`: Set to `true` to create the backend application.
    - `backend_container_port`: The container port for the backend application.
    - `backend_target_group_health_check_config`: Configuration for health checks of the backend application load balancer target group.
    - `backend_cloudfront_price_class`: Price class for backend CloudFront distribution.
    - `backend_expose_admin_only`: Configure if backend should be publicly accessible or only for admins (internal traffic).
    - `backend_container_image`:  URL for the backend Docker image.
    - `backend_resources`:  Resource allocation (instances, cpu, memory) for backend application.
    - `backend_logs`: CloudWatch logs group configuration for the backend application.
    - `backend_run_migrations`: Specifies if to run database migrations
    - `backend_seed_create` and `backend_seed_run`:  Specifies if database seeding shall be performed.
    - `backend_seed_command`: Specifies the seed command to run.
    - `backend_seed_timeout`: Specifies the timeout for seed command.
    - `backend_seed_fail_on_error`: Specifies if seeding process shall fail in case of error.
    - `backend_extra_security_group_ids`: Additional security group IDs to attach to backend.
    - `backend_extra_environment_variables`:  Extra environment variables for the backend application.
    - `backend_extra_secrets`: Extra secrets to inject into backend application.
  - **Storefront Configuration:**
    - `storefront_create`: Set to `true` to create the storefront application.
    - `storefront_container_port`: The container port for the storefront application.
    - `storefront_target_group_health_check_config`: Configuration for health checks of the storefront application load balancer target group.
    - `storefront_cloudfront_price_class`: Price class for storefront CloudFront distribution.
    - `storefront_container_image`: URL for the storefront Docker image.
    - `storefront_resources`: Resource allocation (instances, cpu, memory) for the storefront application.
    - `storefront_logs`: CloudWatch logs group configuration for the storefront application.
    - `storefront_extra_security_group_ids`: Additional security group IDs to attach to storefront.
    - `storefront_extra_environment_variables`: Extra environment variables for the storefront application.
    - `storefront_extra_secrets`: Extra secrets to inject into storefront application.
  - `output` blocks: Define values that will be displayed after deployment.
</details>

### Deployment

1.  Initialize Terraform:
    ```bash
    terraform init
    ```
    This command will download the necessary providers and modules.
1.  (Optional) Create a Terraform [workspace](https://developer.hashicorp.com/terraform/cli/workspaces): To keep environments separated, you can create a workspace for your deployment. Example for `medusa-complete` workspace is:
    ```bash
    terraform workspace new medusa-complete
    terraform workspace select medusa-complete
    ```
1.  Plan the deployment:
    ```bash
    terraform plan
    ```
    This command will show you what resources Terraform will create, modify, or destroy. Review the plan carefully.
1.  Apply the deployment:
    ```bash
    terraform apply
    ```
    Terraform will prompt you to confirm the changes. Type `yes` to proceed with the deployment.
    This will deploy the complete infrastructure on AWS. It may take some time to complete.

### Outputs

After successful deployment, Terraform will display output values. These include:
- `ecr_backend_url`: The URL of the backend ECR repository.
- `ecr_storefront_url`: The URL of the storefront ECR repository.
- `backend_url`: The URL of the deployed backend application.
- `storefront_url`: The URL of the deployed storefront application.

## Customization

- Adjust the `locals` block: Modify the project and environment variables to suit your needs.
- Change the AWS `region`: Modify the region value within the provider "aws" block.
- Customize the module parameters: Explore the documentation for the `u11d-com/terraform-aws-medusajs` module to understand all possible customization options. You can find the documentation in the module's repository or in the Terraform Registry.
- **ECR Configuration:** Customize the retention policies of ECR repositories
- **Network Configuration:** Adjust the VPC settings like `cidr_block` and number of `az_count`
- **Redis and PostgreSQL Configuration:** Change instance types, number of nodes, and database versions.
- **Application Configuration:** Customize the container ports, health checks, resources, environment variables, secrets, logging and security group settings for the backend and storefront.
- **Migration and Seeding Configuration:** Control the process of database migrations and initial data population

## Troubleshooting

- Check Terraform logs: If deployment fails, carefully inspect the logs output by Terraform.
- Verify AWS credentials: Ensure your AWS CLI is configured correctly and has the required permissions.
- Verify VPC settings: Ensure that the VPC and subnets configuration is proper.
- Verify External registry credentials: Ensure that external registry credentials are correct and user has proper permissions to access images.
- Seek community support: If you encounter issues you can not solve on your own, consider seeking help from the Terraform community or in the module's repository's issue tracker.
- :email: [Contact us](mailto:hello@u11d.com) to for support or development.

## Contributing

Feel free to contribute to this example or the `u11d-com/terraform-aws-medusajs` module. Bug fixes, new features, and documentation improvements are welcome. Fork the repository, make your changes, and submit a pull request.

## License

This example is licensed under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0).


---
:heart: _Technology made with passion by u11d_