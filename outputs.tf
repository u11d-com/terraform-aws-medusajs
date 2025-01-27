output "ecr_backend_url" {
  value = var.ecr_backend_create ? module.ecr_backend[0].url : null
}

output "ecr_storefront_url" {
  value = var.ecr_storefront_create ? module.ecr_storefront[0].url : null
}

output "backend_url" {
  value = var.backend_create ? module.backend[0].url : var.backend_url
}

output "storefront_url" {
  value = var.storefront_create ? module.storefront[0].url : null
}
