output "url" {
  value = "redis://${aws_elasticache_cluster.main.cache_nodes[0].address}:${aws_elasticache_cluster.main.cache_nodes[0].port}"
}

output "client_security_group_id" {
  value = aws_security_group.client.id
}
