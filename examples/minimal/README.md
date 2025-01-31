# MedusaJS Minimal Infrastructure on AWS with Terraform

This Terraform configuration deploys a minimal [MedusaJS](https://medusajs.com/) e-commerce platform infrastructure on AWS using the publicly available [`u11d-com/terraform-aws-medusajs`](https://github.com/u11d-com/terraform-aws-medusajs) module. This example is designed for quick setup and demonstration purposes. It provides a foundation for more complex MedusaJS deployments on AWS infrastructure.

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

- Deploys a minimal MedusaJS backend infrastructure.
- Uses a pre-built backend Docker image from GitHub Registry `ghcr.io/u11d-com/medusa-backend`.
- Optionally seeds the database during deployment.
- Creates an Elastic Container Registry (ECR) repository to store your custom frontend images.
- Provides outputs for accessing the deployed resources.
- Configurable using Terraform variables.

## Deployment Strategy
MedusaJS starter kits typically use the Next.js framework to build the storefront web application. Next.js requires that the MedusaJS backend is available and responsive during the build process to properly fetch data and create a fully functional storefront. This is important because storefront will be built using the API provided by the backend application.

This module is configured to create an Elastic Container Registry (ECR) for your storefront image. The typical deployment process involves the following steps:

1. **Deploy the MedusaJS backend:** First, you must deploy the backend infrastructure using this Terraform module. Obtain the backend URL from the module's output.
2.  **Build and push the storefront image:** Build your Next.js storefront application, pointing it to the deployed backend URL from step 1. Then, either build a Docker image of your storefront and push it to the ECR repository created by this module, *or use a pre-built storefront image and proceed to step 3*.
3.  **Deploy the storefront:** Finally, you can configure this module to deploy storefront from the image stored in your ECR, by setting `storefront_create` option to true and providing proper image tag. If you already have a prebuilt storefront application as a Docker image, you can use this module to deploy it, by providing the `storefront_container_image` variable with the full image path including the tag.

While this module primarily focuses on backend deployment, it also supports storefront deployment as mentioned in step 3.


## Prerequisites

Before you begin, make sure you have the following:

- **Terraform:** Version `~> 1.9` or higher installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- **AWS Account:** An active AWS account with appropriate permissions to create resources.
- **AWS CLI:** The AWS Command Line Interface configured with your credentials. You can find instructions on how to install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Basic understanding of Terraform:** Familiarity with basic Terraform concepts like providers, modules, and outputs.
- **Docker:** (Optional) If you plan to create custom Docker images for MedusaJS. Install from [official Docker website](https://docs.docker.com/engine/install/).

## Usage

### Configuration

1. Clone this repository: [terraform-aws-medusajs](https://github.com/u11d-com/terraform-aws-medusajs)
    ```bash
    git clone https://github.com/u11d-com/terraform-aws-medusajs.git
    cd terraform-aws-medusajs/examples/minimal
    ```

<details>

<summary>2. Review the <code>main.tf</code> file (click to expand)</summary>

This file contains the Terraform configuration for deploying the MedusaJS infrastructure.
- terraform block: Specifies the required Terraform version.
- locals block: Defines local variables for project and environment names. You can customize these.
- provider "aws" block: Configures the AWS provider and sets default tags for all resources. Change the region to match your desired location.
- module "minimal" block: This is the core of the setup. It uses the `u11d-com/terraform-aws-medusajs` module to create your infrastructure. Here's a breakdown of the key parameters:
  - source: The location of the Terraform module.
  - project and environment: These parameters are passed to the module and may be used to tag the AWS resources or other logic inside the module
  - ecr_storefront_create: Creates storefront ECR repository.
  - backend_container_image: Specifies the Docker image for the MedusaJS backend. We are using prebuilt public image `ghcr.io/u11d-com/medusa-backend:1.20.10-latest` in this example, but you can point to your custom image.
  - backend_seed_create and backend_seed_run: Specifies if to run seeding command after deployment, by default is set to true
  - backend_extra_environment_variables: allows you to configure backend runtime variables. In the example `NODE_ENV` is set to `development`.
  - storefront_create: Controls if storefront deployment is executed. In this example is set to `false`, but in case of storefront deployment set to `true`.
  - storefront_container_image: If storefront_create is set to `true`, this variable provides url to docker image for the storefront.
- output blocks: Define values that will be displayed after deployment.
</details>

### Deployment
1. Initialize Terraform:
    ```bash
    terraform init
    ```
    This command will download the necessary providers and modules.
1. (Optional) Create a Terraform [workspace](https://developer.hashicorp.com/terraform/cli/workspaces): To keep environments separated, you can create a workspace for your deployment. Example for `medusa-minimal` workspace is:
    ```bash
    terraform workspace new medusa-minimal
    terraform workspace select medusa-minimal
    ```
1. Plan the deployment:
    ```bash
    terraform plan
    ```
    This command will show you what resources Terraform will create, modify, or destroy. Review the plan carefully.
1. Apply the deployment:
    ```bash
    terraform apply
    ```
    Terraform will prompt you to confirm the changes. Type `yes` to proceed with the deployment.
    This will deploy the defined infrastructure on AWS. It may take some time to complete.

### Outputs
After successful deployment, Terraform will display output values. These include:
- `ecr_backend_url`: The URL of the backend ECR repository (if ecr_backend_create = true in the module).
- `ecr_storefront_url`: The URL of the storefront ECR repository (if ecr_storefront_create = true in the module).
- `backend_url`: The URL of the deployed backend application (if backend_create = true in the module).
- `storefront_url`: The URL of the deployed storefront application (if storefront_create = true in the module).

## Customization
- Adjust the `locals` block: Modify the project and environment variables to suit your needs.
- Change the AWS `region`: Modify the region value within the provider "aws" block.
- Customize the module parameters: Explore the documentation for the `u11d-com/terraform-aws-medusajs` module to understand all possible customization options. You can find the documentation in the module's repository or in the Terraform Registry.
- **Use custom or pre-built Docker images:**
   - You can build your own Docker images for the backend and storefront, and specify the image URLs in the `backend_container_image` and `storefront_container_image` variables.
   - Alternatively, if you already have a pre-built storefront Docker image, you can provide its URL to the `storefront_container_image` variable. This bypasses the need to build storefront from the source during deployment.
- Configure additional environment variables: Add more environment variables to `backend_extra_environment_variables` to configure your MedusaJS application.
- Enable the storefront: To deploy the storefront, set `storefront_create` to true and provide a valid `storefront_container_image`.

## Troubleshooting
- Check Terraform logs: If deployment fails, carefully inspect the logs output by Terraform.
- Verify AWS credentials: Ensure your AWS CLI is configured correctly and has the required permissions.
- Seek community support: If you encounter issues you can not solve on your own, consider seeking help from the Terraform community or in the module's repository's issue tracker.
- :email: [Contact us](mailto:hello@u11d.com) for support or development.

## Contributing
Feel free to contribute to this example or the `u11d-com/terraform-aws-medusajs` module. Bug fixes, new features, and documentation improvements are welcome. Fork the repository, make your changes, and submit a pull request.

## License
This example is licensed under the [Apache-2.0 license](https://www.apache.org/licenses/LICENSE-2.0).


---
:heart: _Technology made with passion by u11d_