locals {
  paths = [for endpoint in keys(var.endpoints) : split(" ", endpoint)[1]]
  api_body = {
    openapi = var.openapi_version
    info = {
      title   = var.api_name
      version = var.api_version
    }
    paths = zipmap(local.paths, [for path in local.paths : {}])
  }
}

resource "aws_api_gateway_rest_api" "main" {
  provider = aws.nwk

  name        = var.api_name
  body        = jsonencode(local.api_body)
  description = "apigateway ONLY for ${var.api_name} api"
  endpoint_configuration {
    types = [var.endpoint_configuration]
  }
  disable_execute_api_endpoint = true
}

data "aws_cognito_user_pools" "main" {
  provider = aws.nwk

  name = var.cognito_user_pool_name
}
resource "aws_api_gateway_authorizer" "main" {
  provider = aws.nwk

  name          = var.api_name
  rest_api_id   = aws_api_gateway_rest_api.main.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = data.aws_cognito_user_pools.main.arns
}
