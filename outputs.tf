output "ip" {
  description = "RDS PostgreSQL instance private IPs"
  value       = huaweicloud_rds_instance.main.private_ips
}

output "port" {
  description = "RDS PostgreSQL instance port"
  value       = huaweicloud_rds_instance.main.db[0].port
}
