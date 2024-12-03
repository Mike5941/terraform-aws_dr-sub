terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/cache/memcached/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "primary"
}

module "primary_cache" {
  source = "github.com/Mike5941/aws_dr-modules//modules/cache/memcached"

  providers = {
    aws.primary
  }

  cluster_id = "primary-memcached"

  web_remote_state_key = "prod/services/web/primary/terraform.tfstate"
  vpc_remote_state_key = "prod/network/primary/terraform.tfstate"
}
