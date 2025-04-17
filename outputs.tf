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

output "backend_ecs_cluster_name" {
  description = "The name of the ECS cluster for the backend service, if created."
  value       = var.backend_create ? module.backend[0].ecs_cluster_name : null
}

output "backend_ecs_service_name" {
  description = "The name of the ECS service for the backend, if created."
  value       = var.backend_create ? module.backend[0].ecs_service_name : null
}

output "storefront_ecs_cluster_name" {
  description = "The name of the ECS cluster for the storefront service, if created."
  value       = var.storefront_create ? module.storefront[0].ecs_cluster_name : null
}

output "storefront_ecs_service_name" {
  description = "The name of the ECS service for the storefront, if created."
  value       = var.storefront_create ? module.storefront[0].ecs_service_name : null
}

output "rds_identifier" {
  description = "The identifier of the RDS instance, if created."
  value       = var.rds_create ? module.rds[0].identifier : null
}


