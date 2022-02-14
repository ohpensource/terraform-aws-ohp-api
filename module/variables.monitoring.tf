variable "enable_xray_tracing" {
  type    = bool
  default = true
}

variable "datadog_forwarder_arn_ssm_parameter_name" {
  type    = string
  default = null
}

variable "apigw_cw_account_role_arn" {
  type        = string
  description = "API GW Account Cloudwatch Role Arn"
  default     = null
}
