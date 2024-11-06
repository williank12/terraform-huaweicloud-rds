output "id" {
  description = "RDS MySQL instance ID"
  value       = huaweicloud_rds_instance.main.id
}

output "private_ips" {
  description = "RDS MySQL instance private IPs"
  value       = huaweicloud_rds_instance.main.private_ips
}

output "public_ips" {
  description = "RDS MySQL instance public IPs"
  value       = huaweicloud_rds_instance.main.public_ips
}

output "port" {
  description = "RDS MySQL instance port"
  value       = huaweicloud_rds_instance.main.db[0].port
}

output "user_name" {
  description = "RDS MySQL User name"
  sensitive   = true
  value       = huaweicloud_rds_instance.main.db[0].user_name
}

output "password" {
  description = "RDS MySQL Password"
  sensitive   = true
  value       = huaweicloud_rds_instance.main.db[0].password
}
