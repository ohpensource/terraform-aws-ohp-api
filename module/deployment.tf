resource "aws_api_gateway_deployment" "main" {
  provider = aws.nwk

  rest_api_id = aws_api_gateway_rest_api.main.id
  triggers = {
    redeployment = timestamp()
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.lambda_integrations
  ]
}

locals {
  access_log_settings = {
    requestId = "$context.requestId"
    identity = {
      ip     = "$context.identity.sourceIp"
      caller = "$context.identity.caller"
      user   = "$context.identity.user"
    }
    requestTime      = "$context.requestTime"
    requestTimeEpoch = "$context.requestTimeEpoch"
    httpMethod       = "$context.httpMethod"
    resourcePath     = "$context.resourcePath"
    status           = "$context.status"
    protocol         = "$context.protocol"
    responseLength   = "$context.responseLength"
    xrayTraceId      = "$context.xrayTraceId"
  }
}

resource "aws_api_gateway_stage" "main" {
  provider = aws.nwk

  rest_api_id          = aws_api_gateway_rest_api.main.id
  stage_name           = var.stage_name
  deployment_id        = aws_api_gateway_deployment.main.id
  xray_tracing_enabled = var.enable_xray_tracing
  dynamic "access_log_settings" {
    for_each = [1]
    content {
      destination_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
      format          = jsonencode(local.access_log_settings)
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.apigw_exec_logs
  ]
}
