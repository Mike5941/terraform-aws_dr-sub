data "aws_region" "tokyo" {
  provider = aws.tokyo
}

data "aws_region" "seoul" {
  provider = aws.seoul
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}