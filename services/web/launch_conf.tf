terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/services/web/terraform.tfstate"
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

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.db_remote_state_key
    region = "ap-northeast-2"
  }
}

module "primary_webserver" {
  source = "../../../modules/services/web"
  depends_on = [module.db_secrets]

  providers = {
    aws = aws.primary
  }

  cluster_name           = "webservers-primary"
  remote_state_bucket = "terraform-wonsoong"
  vpc_remote_state_key    = "prod/vpc/primary/terraform.tfstate"

  db_username = module.db_secrets.db_credentials["username"]
  db_password = module.db_secrets.db_credentials["password"]
  db_name = data.terraform_remote_state.db.outputs.primary_dbname
  db_host = data.terraform_remote_state.db.outputs.primary_address
  db_port = data.terraform_remote_state.db.outputs.primary_port
}

#module "secondary_webserver" {
#  source = "../../../modules/services/web"
#
#  providers = {
#    aws = aws.secondary
#  }
#
#  cluster_name           = "webservers-secondary"
#  remote_state_bucket = "terraform-wonsoong"
#  vpc_remote_state_key    = "prod/vpc/secondary/terraform.tfstate"
#  db_username = local.db_username
#  db_password = local.db_password
#  db_host = data.terraform_remote_state.db.outputs.secondary_address
#  db_port = data.terraform_remote_state.db.outputs.secondary_port
#}

module "db_secrets" {
  source      = "../../../global/secrets"
  secret_name = "MyDatabaseSecret"
}