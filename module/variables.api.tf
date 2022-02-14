variable "endpoint_configuration" {
  type    = string
  default = "REGIONAL"
}

variable "api_name" {
  type = string
}

variable "api_version" {
  type = string
}

variable "api_base_path" {
  type = string
}

variable "openapi_version" {
  type    = string
  default = "3.0.1"
}

variable "endpoints" {
  type = map(any)
}

variable "domain_name" {
  type = string
}

variable "stage_name" {
  type = string
}
