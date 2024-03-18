#resource "aws_ec2_client_vpn_endpoint" "vpn" {
#  depends_on             = [module.primary.vpc_id]
#  server_certificate_arn = var.server_arn
#
#  client_cidr_block = "10.10.0.0/16"
#  split_tunnel      = true
#
#  authentication_options {
#    type                       = "certificate-authentication"
#    root_certificate_chain_arn = var.client_arn
#  }
#
#  connection_log_options {
#    enabled = false
#  }
#
#}
#
#resource "aws_ec2_client_vpn_network_association" "vpn" {
#  depends_on             = [module.primary.public_subnets]
#  count                  = length(module.primary.public_subnets)
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
#  subnet_id              = module.primary.public_subnets[count.index]
#}
#
#resource "aws_ec2_client_vpn_authorization_rule" "vpn" {
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
#  target_network_cidr    = "0.0.0.0/0"
#  authorize_all_groups   = true
#}
#
## Client VPN endpoint ARN
##----------------------------------------
#variable "server_arn" {
#  type    = string
#  default = "arn:aws:acm:ap-northeast-2:675481538193:certificate/102a031f-0292-44be-825a-5001b0c517a7"
#}
#
#variable "client_arn" {
#  type    = string
#  default = "arn:aws:acm:ap-northeast-2:675481538193:certificate/9a11f97f-ebb1-4020-bc55-923a9e14bd4d"
#}
