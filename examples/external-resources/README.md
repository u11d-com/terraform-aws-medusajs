# MedusaJS Infrastructure on AWS with External Resources: Existing VPC and External Image Repository

This Terraform configuration deploys a MedusaJS e-commerce platform infrastructure on AWS using the publicly available [`u11d-com/terraform-u11d-medusajs`](https://github.com/u11d-com/terraform-u11d-medusajs) module, utilizing **existing** VPC and external container registries. In addition to that, it also deploys ElastiCache Redis and RDS PostgreSQL databases as part of its infrastructure. This example demonstrates how to integrate your existing AWS infrastructure with the MedusaJS deployment and includes essential database components.

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

MedusaJS starter kits typically use the Next.js framework to build the storefront web application. Next.js requires that the MedusaJS backend is available and responsive during the build process to properly fetch data and create a fully functional storefront. This is important because storefront will be built with the API provided by backend application.

Therefore, the deployment process can be divided into two main steps:

1. **Deploy the MedusaJS backend:** First, you must deploy the backend infrastructure using this Terraform module. Obtain the backend URL from the module's output.
1. **Build and Deploy the storefront:** After the backend is deployed and running, you can proceed to build your Next.js storefront application, pointing it to deployed backend URL from step 1. Once storefront application is built, deploy it to the infrastructure of your choice. If you already have prebuilt storefront application as a Docker image, you can use this module to deploy it, by providing `storefront_container_image` value.

This module focuses on the backend deployment but can deploy storefront if `storefront_create` option is set to true and proper `storefront_container_image` is provided.

## Prerequisites

Before you begin, make sure you have the following:

- **Terraform:** Version `~> 1.10.0` or higher installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- **AWS Account:** An active AWS account with appropriate permissions to create resources.
- **AWS CLI:** The AWS Command Line Interface configured with your credentials. You can find instructions on how to install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Basic understanding of Terraform:** Familiarity with basic Terraform concepts like providers, modules, and outputs.
- **Docker:** (Optional) If you plan to create custom Docker images for MedusaJS. Install from [official Docker website](https://docs.docker.com/engine/install/).
- **Existing AWS VPC:** You must have an existing VPC with available public and private subnets. You'll need to provide the IDs of these resources.
- **External Container Registry:** You must have access to a container registry that hosts your MedusaJS backend and storefront Docker images. You'll need the registry URL, username, and password if authentication is required.

## Usage

### Configuration

1. Clone this repository: [terraform-u11d-medusajs](https://github.com/u11d-com/terraform-u11d-medusajs)
    ```bash
    git clone https://github.com/u11d-com/terraform-u11d-medusajs.git
    cd terraform-u11d-medusajs
    ```

<details>

<summary>2. Review the <code>main.tf</code> file (click to expand)</summary>

This file contains the Terraform configuration for deploying the MedusaJS infrastructure.
  - terraform block: Specifies the required Terraform version.
  - locals block: Defines local variables for project and environment names. You can customize these.
  - provider "aws" block: Configures the AWS provider and sets default tags for all resources. Change the region to match your desired location.
  - module "external_resources" block: This is the core of the setup. It uses the `u11d-com/terraform-u11d-medusajs` module to create your infrastructure with external resources. Here's a breakdown of the key parameters:
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

- `ecr_backend_url`: The URL of the backend ECR repository (only available if `ecr_backend_create = true` in the module). In this example, this output will be empty as no ECR repository will be created.
- `ecr_storefront_url`: The URL of the storefront ECR repository (only available if `ecr_storefront_create = true` in the module).  In this example, this output will be empty as no ECR repository will be created.
- `backend_url`: The URL of the deployed backend application.
- `storefront_url`: The URL of the deployed storefront application.

## Customization

- Adjust the `locals` block: Modify the project and environment variables to suit your needs.
- Change the AWS `region`: Modify the region value within the provider "aws" block.
- Customize the module parameters: Explore the documentation for the `u11d-com/terraform-u11d-medusajs` module to understand all possible customization options. You can find the documentation in the module's repository or in the Terraform Registry.
- **Use existing VPC:** Make sure that `vpc_create` is set to `false` and provide correct `vpc_id`, `public_subnet_ids`, and `private_subnet_ids` values.
- **Use external container registries:** Provide valid container image URLs, `backend_container_image` and `storefront_container_image` , and credentials if needed,  `backend_container_registry_credentials` and `storefront_container_registry_credentials`.
- Configure additional environment variables: Add more environment variables to `backend_extra_environment_variables` to configure your MedusaJS application.

## Troubleshooting

- Check Terraform logs: If deployment fails, carefully inspect the logs output by Terraform.
- Verify AWS credentials: Ensure your AWS CLI is configured correctly and has the required permissions.
- Verify VPC and subnet settings: Ensure the provided VPC and subnet IDs are correct and that the subnets have the required configurations.
- Verify External registry credentials: Ensure that external registry credentials are correct and user has proper permissions to access images.
- Consult module documentation: For specific issues related to the `u11d-com/terraform-u11d-medusajs` module, refer to its documentation.
- Seek community support: If you encounter issues you can not solve on your own, consider seeking help from the Terraform community or in the module's repository's issue tracker.
- :email: [Contact us](mailto:hello@u11d.com) for support or development

## Contributing

Feel free to contribute to this example or the `u11d-com/terraform-u11d-medusajs` module. Bug fixes, new features, and documentation improvements are welcome. Fork the repository, make your changes, and submit a pull request.

## License

This example is licensed under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0).



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
| <a name="module_external_resources"></a> [external\_resources](#module\_external\_resources) | u11d-com/terraform-u11d-medusajs | n/a |

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

---
:heart: _Technology made with passion by u11d_