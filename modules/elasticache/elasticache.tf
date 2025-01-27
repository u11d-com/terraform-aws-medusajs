resource "aws_elasticache_subnet_group" "main" {
  name        = "${local.prefix}-db-subnet-group"
  description = "Elasticache subnet group used by ${local.prefix}."

  subnet_ids = var.vpc.private_subnet_ids

  tags = local.tags
}

resource "aws_elasticache_cluster" "main" {
  cluster_id = "${local.prefix}-cluster"

  engine             = "redis"
  node_type          = var.node_type
  num_cache_nodes    = var.nodes_num
  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.server.id]
  port               = var.port
  engine_version     = var.redis_engine_version

  tags = local.tags
}
