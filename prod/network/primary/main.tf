terraform {
  backend "remote" {
    organization = "wonsoong"

    workspaces {
      name = "terraform-aws_dr-sub"
    }
  }
}

module "primary" {
  source  = "app.terraform.io/wonsoong/module/vpc"
  version = "1.0.3"
  project_name = "primary"
  vpc_cidr     = "10.1.0.0/16"
}



