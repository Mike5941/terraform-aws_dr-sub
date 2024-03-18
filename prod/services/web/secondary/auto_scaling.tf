terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/services/web/secondary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "secondary"
}


module "db_secrets" {
  source      = "github.com/Mike5941/aws_dr-sub//global/secrets"
  secret_name = "prod/database/MySQL"
}


module "secondary_webserver" {
  source = "github.com/Mike5941/aws_dr-modules//modules/services/web"

  providers = {
    aws = aws.secondary
  }

  cluster_name         = "webservers-secondary"
  remote_state_bucket  = "terraform-wonsoong"
  vpc_remote_state_key = "prod/network/secondary/terraform.tfstate"
  private_ip           = "10.2.1.100"
  max_size = 1
  min_size = 0
  record_id = "secondary-set"
  route_policy_type = "SECONDARY"


  db_username = module.db_secrets.db_credentials["username"]
  db_password = module.db_secrets.db_credentials["password"]
  db_name     = data.terraform_remote_state.db.outputs.primary_dbname
  db_host     = data.terraform_remote_state.db.outputs.secondary_address
  db_port     = data.terraform_remote_state.db.outputs.secondary_port
}

