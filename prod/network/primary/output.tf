output "vpc_id" {
  description = "VPC ID"
  value       = module.primary.vpc_id
}

output "public_subnets" {
  description = "Public Subnet ID"
  value       = module.primary.public_subnets
}

output "private_subnets" {
  description = "Private Subnet ID"
  value       = module.primary.private_subnets
}

output "azs" {
  value = module.primary.azs
}



#output "vpn_endpoint_id" {
#  value = aws_ec2_client_vpn_endpoint.vpn.id
#}


