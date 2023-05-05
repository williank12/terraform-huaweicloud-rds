output "id" {
  description = "RDS PostgreSQL instance ID"
  value       = huaweicloud_rds_instance.main.id
}

output "private_ips" {
  description = "RDS PostgreSQL instance private IPs"
  value       = huaweicloud_rds_instance.main.private_ips
}

output "public_ips" {
  description = "RDS PostgreSQL instance public IPs"
  value       = huaweicloud_rds_instance.main.public_ips
}

output "port" {
  description = "RDS PostgreSQL instance port"
  value       = huaweicloud_rds_instance.main.db[0].port
}

output "user_name" {
  description = "RDS PostgreSQL User name"
  sensitive   = true
  value       = huaweicloud_rds_instance.main.db[0].user_name
}

output "password" {
  description = "RDS PostgreSQL Password"
  sensitive   = true
  value       = huaweicloud_rds_instance.main.db[0].password
}
