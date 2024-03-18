terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/cache/memcached/secondary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "secondary"
}

module "secondary_cache" {
  source = "github.com/Mike5941/aws_dr-modules//modules/cache/memcached"

  providers = {
    aws = aws.secondary
  }

  cluster_id           = "secondary-memcached"
  vpc_remote_state_key = "prod/network/secondary/terraform.tfstate"
  web_remote_state_key = "prod/services/web/secondary/terraform.tfstate"

}
