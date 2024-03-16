terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "stage/services/web/primary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

module "db_secrets" {
  source      = "../../../../global/secrets"
  secret_name = "MyDatabaseSecret"
}

module "primary_webserver" {
  source     = "../../../../../modules/services/web"
  depends_on = [module.db_secrets]
  cluster_name         = "webserver-primary"
  remote_state_bucket  = "terraform-wonsoong"
  vpc_remote_state_key = "stage/network/primary/terraform.tfstate"
  private_ip           = "10.1.1.100"
  max_size             = 1
  min_size             = 1
#  listener_port = 81
  record_id = "primary-set"
  route_policy_type = "PRIMARY"
  health_check_id = aws_route53_health_check.example.id

  db_username = module.db_secrets.db_credentials["username"]
  db_password = module.db_secrets.db_credentials["password"]
  db_name     = data.terraform_remote_state.db.outputs.primary_dbname
  db_host     = data.terraform_remote_state.db.outputs.primary_address
  db_port     = data.terraform_remote_state.db.outputs.primary_port
}

resource "aws_cloudwatch_metric_alarm" "synthetics_alarm_bottari_canary_1" {
  alarm_name                = "Synthetics-Alarm-bottari-canary"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 1
  metric_name               = "SuccessPercent"
  namespace                 = "CloudWatchSynthetics"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "Alarm when SuccessPercent is less than 90%"
  datapoints_to_alarm       = 1
  treat_missing_data        = "missing"

  dimensions = {
    CanaryName = "pilotlight-canary"
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm_topic.arn]
  ok_actions      = [aws_sns_topic.alarm_topic.arn]

  tags = {
    Name = "Synthetics-Alarm-bottari-canary-1"
  }
}

resource "aws_route53_health_check" "example" {
  type              = "CLOUDWATCH_METRIC"

  cloudwatch_alarm_name   = aws_cloudwatch_metric_alarm.synthetics_alarm_bottari_canary_1.alarm_name
  cloudwatch_alarm_region = "ap-northeast-2"
  insufficient_data_health_status = "Healthy"

  tags = {
    Name = "cloudwatch-health-check"
  }

}

resource "aws_sns_topic" "alarm_topic" {
  name = "cloudwatch-alarms-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = "mike9159@naver.com"
}
