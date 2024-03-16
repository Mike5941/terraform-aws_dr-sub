output "vpc_id" {
  description = "VPC ID"
  value = module.primary.vpc_id
}

output "public_subnets" {
  description = "Public Subnet ID"
  value = module.primary.public_subnets
}

output "private_subnets" {
  description = "Private Subnet ID"
  value = module.primary.private_subnets
}

output "database_subnets" {
  description = "Database Subnet ID"
  value = module.primary.database_subnets
}

output "azs"{
  value = module.primary.azs
}

output "db_subnet_group" {
  description = "RDS Subnet Group Name"
  value = module.primary.db_subnet_groups
}

output "cache_subnet_group" {
  description = "Cache Subnet Group Name"
  value = module.primary.cache_subnet_groups
}

output "vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.vpn.id
}


