variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

variable "lambda_qualified_arn" {
  description = "ARN of the Lambda function with alias"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_alias_name" {
  description = "Name of the Lambda function alias"
  type        = string
}

variable "primary_resource_path" {
  description = "Path part for the primary API resource"
  type        = string
}

variable "secondary_resource_path" {
  description = "Path part for the secondary API resource"
  type        = string
}
