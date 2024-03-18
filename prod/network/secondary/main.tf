terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/network/secondary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "secondary"
}

module "secondary" {
  source = "github.com/Mike5941/aws_dr-modules//modules/network"

  providers = {
    aws = aws.secondary
  }

  project_name = "WEB-Secondary"
  vpc_cidr     = "10.2.0.0/16"

}

