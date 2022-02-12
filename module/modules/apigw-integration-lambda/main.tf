data "aws_api_gateway_resource" "main" {
  provider = aws.nwk

  for_each = var.endpoints

  rest_api_id = var.rest_api_id
  path        = local.url_by_endpoint[each.key]
}

resource "aws_api_gateway_method" "main" {
  provider = aws.nwk

  for_each = var.endpoints

  rest_api_id          = var.rest_api_id # data.aws_api_gateway_rest_api.main.id
  resource_id          = data.aws_api_gateway_resource.main[each.key].id
  http_method          = local.method_by_endpoint[each.key]
  authorization        = local.cognito_user_pools
  authorizer_id        = var.authorizer_id
  authorization_scopes = var.endpoints[each.key].allowed_authorization_scopes
}

data "aws_lambda_function" "main" {
  provider = aws.domain

  for_each = var.endpoints

  function_name = each.value.configuration.lambda_function_name
}
resource "aws_api_gateway_integration" "main" {
  provider = aws.nwk

  for_each = var.endpoints

  rest_api_id             = var.rest_api_id
  resource_id             = data.aws_api_gateway_resource.main[each.key].id
  http_method             = aws_api_gateway_method.main[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.main[each.key].invoke_arn
}

resource "aws_lambda_permission" "main" {
  provider = aws.domain

  for_each = toset(local.lambda_functions) # var.endpoints

  statement_id_prefix = "ohpen-api-"
  action              = "lambda:InvokeFunction"
  function_name       = each.key
  principal           = "apigateway.amazonaws.com"
  # source_arn          = local.source_arn_by_endpoint[each.key]
  source_arn = "${var.rest_api_exec_arn}/*/*/*"
}

########################################################
# If you want to enable permissions per method 
# comment out the permission block above and 
# uncomment the block below. 
#
# Be aware that permissions per method creates a big 
# resource policy and there is a hard limit to how big 
# it can be
########################################################


# resource "aws_lambda_permission" "main" {
#   provider = aws.domain

#   for_each = var.endpoints

#   statement_id_prefix = "ohpen-api-"
#   action              = "lambda:InvokeFunction"
#   function_name       = each.key
#   principal           = "apigateway.amazonaws.com"
#   source_arn          = local.source_arn_by_endpoint[each.key]
# }
