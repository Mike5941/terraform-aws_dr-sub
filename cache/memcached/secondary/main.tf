#terraform {
#  backend "s3" {
#    bucket = "terraform-wonsoong"
#    key    = "prod/cache/memcached/terraform.tfstate"
#    region = "ap-northeast-2"
#
#    dynamodb_table = "terraform-wonsoong"
#    encrypt        = true
#  }
#}
#
#provider "aws" {
#  region = "ap-northeast-1"
#  alias = "secondary"
#}
#
#module "secondary_cache" {
#  source = "../../../../modules/cache/memcached"
#
#  cluster_id = "secondary-memcached"
#
#  providers = {
#    aws = aws.secondary
#  }
#
##  vpc_id = data.terraform_remote_state.secondary_vpc.outputs.vpc_id
#}
