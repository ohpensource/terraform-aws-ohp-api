locals {
  lambda_endpoints               = compact([for endpoint, integration in var.endpoints : integration.integration_type == "LAMBDA" ? endpoint : ""])
  lambda_integration_by_endpoint = zipmap(local.lambda_endpoints, [for endpoint in local.lambda_endpoints : var.endpoints[endpoint]])
}
module "lambda_integrations" {
  source = "./modules/apigw-integration-lambda"

  providers = {
    aws.nwk    = aws.nwk
    aws.domain = aws.domain
  }

  rest_api_id                                   = aws_api_gateway_rest_api.main.id
  rest_api_exec_arn                             = aws_api_gateway_rest_api.main.execution_arn
  lambda_execution_permission_source_arn_prefix = "arn:aws:execute-api:${var.aws_region}:${var.aws_nwk_account_id}"
  endpoints                                     = local.lambda_integration_by_endpoint
  authorizer_id                                 = aws_api_gateway_authorizer.main.id

  depends_on = [
    aws_api_gateway_rest_api.main,
  ]
}
