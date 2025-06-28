variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "function_description" {
  description = "Description of the Lambda function"
  type        = string
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
}

variable "memory_size" {
  description = "Memory size for the Lambda function"
  type        = number
}

variable "timeout" {
  description = "Timeout for the Lambda function"
  type        = number
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "lambda_alias_name" {
  description = "Name of the Lambda function alias"
  type        = string
  default     = "QA-tested"
}

variable "lambda_alias_description" {
  description = "Description of the Lambda function alias"
  type        = string
  default     = "QA tested version"
}
