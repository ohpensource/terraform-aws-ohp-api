locals {
  cognito_user_pools = "COGNITO_USER_POOLS"

  method_by_endpoint = zipmap(keys(var.endpoints), [for endpoint in keys(var.endpoints) : split(" ", endpoint)[0]])
  url_by_endpoint    = zipmap(keys(var.endpoints), [for endpoint in keys(var.endpoints) : split(" ", endpoint)[1]])
  source_arn_prefix  = var.lambda_execution_permission_source_arn_prefix

  # source_arn_by_endpoint is only needed if we assign lambda invoke permissions per method
  source_arn_by_endpoint = zipmap(keys(var.endpoints), [for endpoint in keys(var.endpoints) : "${var.rest_api_exec_arn}/*/${local.method_by_endpoint[endpoint]}${local.url_by_endpoint[endpoint]}"])
  lambda_functions       = distinct([for i in data.aws_lambda_function.main : i.function_name])
}
