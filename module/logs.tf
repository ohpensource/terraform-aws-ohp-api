data "aws_ssm_parameter" "datadog_forwarder_arn" {
  provider = aws.nwk

  count = var.datadog_forwarder_arn_ssm_parameter_name != null ? 1 : 0

  name = var.datadog_forwarder_arn_ssm_parameter_name
}

resource "aws_cloudwatch_log_subscription_filter" "apigw_logs_datadog" {
  provider = aws.nwk

  count = var.datadog_forwarder_arn_ssm_parameter_name != null ? 1 : 0

  name           = "${var.api_name}-datadog-subscription"
  role_arn       = var.apigw_cw_account_role_arn
  log_group_name = aws_cloudwatch_log_group.apigw_exec_logs.name

  destination_arn = data.aws_ssm_parameter.datadog_forwarder_arn.0.value
  filter_pattern  = ""

  depends_on = [
    aws_cloudwatch_log_group.apigw_exec_logs
  ]
}

resource "aws_api_gateway_method_settings" "main" {
  provider = aws.nwk

  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"
  settings {
    logging_level        = var.logging_level
    data_trace_enabled   = var.data_trace_enabled
    metrics_enabled      = var.metrics_enabled
    cache_data_encrypted = var.cache_data_encrypted
  }
}

resource "aws_cloudwatch_log_group" "apigw_access_logs" {
  provider = aws.nwk

  name              = "${var.api_name}-access-logs"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "apigw_exec_logs" {
  provider = aws.nwk

  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.main.id}/${var.stage_name}"
  retention_in_days = var.logs_retention_in_days
}
