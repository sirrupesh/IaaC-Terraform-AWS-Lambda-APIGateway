variable "api_keys" {
  description = "API keys to create"
  type = list(object({
    name        = string
    description = string
  }))
}

variable "usage_plan" {
  description = "Usage plan configuration"
  type = object({
    name        = string
    description = string
  })
}

variable "api_id" {
  description = "ID of the API Gateway"
  type        = string
}

variable "api_stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "api_key_enabled" {
  description = "Whether the API key is enabled"
  type        = bool
  default     = true
}

variable "throttle_settings" {
  description = "Throttle settings for the usage plan"
  type = object({
    burst_limit = number
    rate_limit  = number
  })
  default = {
    burst_limit = 20
    rate_limit  = 10
  }
}

variable "quota_settings" {
  description = "Quota settings for the usage plan"
  type = object({
    limit  = number
    period = string
  })
  default = {
    limit  = 1000
    period = "MONTH"
  }
}
