# Medusa Infrastructure on AWS with External Resources: Existing VPC and External Image Repository

This Terraform configuration deploys a Medusa e-commerce platform infrastructure on AWS using the publicly available [`u11d-com/terraform-aws-medusajs`](https://registry.terraform.io/modules/u11d-com/medusajs/aws/latest) module, utilizing **existing** VPC and external container registries. In addition to that, it also deploys ElastiCache Redis and RDS PostgreSQL databases as part of its infrastructure. This example demonstrates how to integrate your existing AWS infrastructure with the Medusa deployment and includes essential database components.

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

- Deploys a Medusa backend and storefront infrastructure.
- Uses **existing** AWS VPC and subnets.
- Uses Docker images from **external** container registries.
- Does not create new ECR repositories, instead uses the provided registry images.
- Supports authentication for private external registries.
- Deploys ElastiCache Redis for caching.
- Deploys RDS PostgreSQL for data persistence.
- Provides outputs for accessing the deployed resources.
- Configurable using Terraform variables.

## Deployment Strategy

Medusa starter kits typically use the Next.js framework to build the storefront web application. Next.js requires that the Medusa backend is available and responsive during the build process to properly fetch data and create a fully functional storefront. This is important because the storefront will be built using the API provided by the backend application.

This module is designed to integrate with *existing* infrastructure and uses *external* container registries for your Medusa storefront image. The typical deployment process involves the following steps:

1. **Deploy the Medusa backend:** First, you must deploy the backend infrastructure using this Terraform module. Obtain the backend URL from the module's output.
2. **Build and push the storefront image:** Build your Next.js storefront application, pointing it to the deployed backend URL from step 1. Then, either build a Docker image of your storefront and push it to your *external* container registry, *or use a pre-built storefront image and proceed to step 3*.
3. **Deploy the storefront:** Finally, you can configure this module to deploy storefront from the image stored in your *external* registry, by setting `storefront_create` option to true and providing proper image path, including the tag, using `storefront_container_image` variable, as well as providing registry credentials. If you already have a prebuilt storefront application as a Docker image, you can use this module to deploy it from your *external* registry, by providing the `storefront_container_image` variable with the full image path, including the tag, and relevant registry credentials.

While this module primarily focuses on backend deployment, it also supports storefront deployment as mentioned in step 3.

## Prerequisites

Before you begin, make sure you have the following:

- **Terraform:** Version `~> 1.9` or higher installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- **AWS Account:** An active AWS account with appropriate permissions to create resources.
- **AWS CLI:** The AWS Command Line Interface configured with your credentials. You can find instructions on how to install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Basic understanding of Terraform:** Familiarity with basic Terraform concepts like providers, modules, and outputs.
- **Docker:** (Optional) If you plan to create custom Docker images for Medusa. Install from [official Docker website](https://docs.docker.com/engine/install/).
- **Existing AWS VPC:** You must have an existing VPC with available public and private subnets. You'll need to provide the IDs of these resources.
- **External Container Registry:** You must have access to a container registry that hosts your Medusa backend and storefront containers images. You'll need the registry URL, username, and password if authentication is required.

## Usage

### Configuration

1. Clone this repository: [terraform-aws-medusajs](https://github.com/u11d-com/terraform-aws-medusajs)

    ```shell
    git clone https://github.com/u11d-com/terraform-aws-medusajs.git
    cd terraform-aws-medusajs/examples/external-resources
    ```

<!-- markdownlint-disable MD033 -->
<details>
<summary>2. Review the <code>main.tf</code> file (click to expand)</summary>

This file contains the Terraform configuration for deploying the Medusa infrastructure.

- `terraform` block: Specifies the required Terraform version.
- `locals` block: Defines local variables for project and environment names. You can customize these.
- `provider "aws"` block: Configures the AWS provider and sets default tags for all resources. Change the region to match your desired location.
- `module "external_resources"` block: This is the core of the setup. It uses the `u11d-com/terraform-aws-medusajs` module to create your infrastructure with external resources. Here's a breakdown of the key parameters:
  - `source`: The location of the Terraform module.
  - `project`, `environment` and `owner`: These parameters are passed to the module and may be used to tag the AWS resources or other logic inside the module
  - `vpc_create`: Set to `false` to indicate usage of an existing VPC.
  - `vpc_id`: ID of the existing VPC.
  - `public_subnet_ids`: A list of IDs of the public subnets in your VPC.
  - `private_subnet_ids`: A list of IDs of the private subnets in your VPC.
  - `ecr_backend_create`: Set to `false` to prevent the creation of backend ECR repository.
  - `ecr_storefront_create`: Set to `false` to prevent the creation of storefront ECR repository.
  - `backend_create`: Specifies if to deploy backend application
  - `backend_container_image`: Specifies the Docker image URL for the Medusa backend.
  - `backend_container_registry_credentials`:  Credentials to access the external backend registry.
  - `storefront_create`: Specifies if to deploy storefront application.
  - `storefront_container_image`: Specifies the Docker image URL for the Medusa storefront.
  - `storefront_container_registry_credentials`:  Credentials to access the external storefront registry.
  - `elasticache_create`: Specifies if to create ElastiCache Redis cluster.
  - `rds_create`: Specifies if to create RDS PostgreSQL database.
- `output` blocks: Define values that will be displayed after deployment.

</details>
<!-- markdownlint-enable MD033 -->

### Deployment

1. Initialize Terraform:

    ```shell
    terraform init
    ```

    This command will download the necessary providers and modules.
2. (Optional) Create a Terraform [workspace](https://developer.hashicorp.com/terraform/cli/workspaces): To keep environments separated, you can create a workspace for your deployment. Example for `medusa-external` workspace is:

    ```shell
    terraform workspace new medusa-external
    terraform workspace select medusa-external
    ```

3. Plan the deployment:

    ```shell
    terraform plan
    ```

    This command will show you what resources Terraform will create, modify, or destroy. Review the plan carefully.
4. Apply the deployment:

    ```shell
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
- **Use external container registries:** Provide valid container image URLs (`backend_container_image` and `storefront_container_image`) and credentials if needed (`backend_container_registry_credentials` and `storefront_container_registry_credentials`).
- Configure additional environment variables: Add more environment variables to `backend_extra_environment_variables` to configure your Medusa application.

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

---
:heart: *Technology made with passion by [u11d](https://u11d.com)*
