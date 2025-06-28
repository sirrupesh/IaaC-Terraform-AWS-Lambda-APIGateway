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
