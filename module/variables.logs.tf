variable "logs_retention_in_days" {
  type    = number
  default = 400
}

variable "logging_level" {
  type    = string
  default = "INFO"
}

variable "data_trace_enabled" {
  type    = bool
  default = false
}

variable "metrics_enabled" {
  type    = bool
  default = true
}

variable "cache_data_encrypted" {
  type    = bool
  default = true
}

