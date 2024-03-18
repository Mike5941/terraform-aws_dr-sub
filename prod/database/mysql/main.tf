terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/database/mysql/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "primary"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "secondary"
}

module "db_secrets" {
  source      = "github.com/Mike5941/aws_dr-sub//global/secrets"
  secret_name = "MyDatabaseSecret"
}


module "primary" {
  source = "github.com/Mike5941/aws_dr-modules//modules/database/mysql"

  providers = {
    aws = aws.primary
  }

  vpc_remote_state_key = "prod/network/primary/terraform.tfstate"
#  web_remote_state_key = "prod/services/web/primary/terraform.tfstate"

  db_name                 = "wordpress_db"
  backup_retention_period = 1

  db_username = module.db_secrets.db_credentials["username"]
  db_password = module.db_secrets.db_credentials["password"]
}

#module "secondary" {
#  source = "github.com/Mike5941/aws_dr-modules//modules/database/mysql"
#
#  providers = {
#    aws = aws.secondary
#  }
#
#  vpc_remote_state_key = "prod/network/secondary/terraform.tfstate"
#
#  replicate_source_db = module.primary.arn
#}
