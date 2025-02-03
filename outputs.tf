output "ecr_backend_url" {
  description = "The URL of the ECR repository for the backend service, if created."
  value       = var.ecr_backend_create ? module.ecr_backend[0].url : null
}

output "ecr_storefront_url" {
  description = "The URL of the ECR repository for the storefront service, if created."
  value       = var.ecr_storefront_create ? module.ecr_storefront[0].url : null
}

output "backend_url" {
  description = "The URL of the backend service, either from the created module or provided externally."
  value       = var.backend_create ? module.backend[0].url : var.backend_url
}

output "storefront_url" {
  description = "The URL of the storefront service, if created."
  value       = var.storefront_create ? module.storefront[0].url : null
}
