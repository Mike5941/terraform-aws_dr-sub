data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-wonsoong"
    key    = "prod/database/mysql/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
