variable "db_remote_state_key" {
  type = string
}

variable "remote_state_bucket" {
  type = string
  default = "terraform-wonsoong"
}

variable "vpc_remote_state_key" {
  type = string
}
