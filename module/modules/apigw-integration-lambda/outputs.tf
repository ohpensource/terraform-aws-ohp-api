
output "integrations_ids" {
  value = { for key, value in var.endpoints : key => aws_api_gateway_integration.main[key].id }
}

output "method_ids" {
  value = distinct([for i in aws_api_gateway_method.main : "${i.id}"])
}

output "resource_ids" {
  value = distinct([for i in aws_api_gateway_method.main : "${i.resource_id}"])
}

output "data_lambdas" {
  value = distinct([for i in data.aws_lambda_function.main : i.function_name])
}
