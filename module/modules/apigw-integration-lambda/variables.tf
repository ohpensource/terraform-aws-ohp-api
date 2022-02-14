variable "rest_api_id" {
  type = string
}
variable "rest_api_exec_arn" {
  type = string
}
variable "lambda_execution_permission_source_arn_prefix" {
  type = string
}
variable "endpoints" {
  type = map(any)
}
variable "authorizer_id" {
  type = string
}
