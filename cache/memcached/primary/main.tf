terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/cache/memcached/primary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias = "primary"
}

provider "aws" {
  region = "ap-northeast-1"
  alias = "secondary"
}


module "primary_cache" {
  source = "../../../../modules/cache/memcached"

  providers = {
    aws = aws.primary
  }

  cluster_id = "primary-memcached"

  tf_remote_state_bucket_name = "terraform-wonsoong"
  tf_remote_state_key = "prod/vpc/primary/terraform.tfstate"
}


module "secondary_cache" {
  source = "../../../../modules/cache/memcached"

  cluster_id = "secondary-memcached"

  providers = {
    aws = aws.secondary
  }

  tf_remote_state_bucket_name = "terraform-wonsoong"
  tf_remote_state_key = "prod/vpc/secondary/terraform.tfstate"
}
