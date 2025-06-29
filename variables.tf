variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "default"
}

# API Gateway variables
variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "sample"
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
  default     = "This is a sample API Gateway"
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "test"
}

# Lambda variables
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "sample"
}

variable "lambda_description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "This is a sample Lambda function that will be used in the API Gateway to add two numbers."
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "lambda_memory_size" {
  description = "Memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function"
  type        = number
  default     = 3
}

# Lambda Alias variables
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

# IAM variables
variable "lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
  default     = "My-AWSLambdaBasicExcutionRole"
}

variable "lambda_role_description" {
  description = "Description of the IAM role for Lambda"
  type        = string
  default     = "Allows Lambda functions to call AWS services on your behalf."
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    POC = "Rupesh"
    Environment = "Test"
    Project = "IaaC-Lambda-APIGateway"
  }
}

variable "lambda_policy_arn" {
  description = "ARN of the policy to attach to the Lambda role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# API Keys and Usage Plan variables
variable "api_keys" {
  description = "API keys to create"
  type = list(object({
    name        = string
    description = string
  }))
  default = [
    {
      name        = "My-N8N API Key"
      description = " Used In N8N Workflow"
    },
    {
      name        = "Rupesh-API-Key"
      description = " Used In Rupesh's Application"
    }
  ]
}

variable "usage_plan" {
  description = "Usage plan configuration"
  type = object({
    name        = string
    description = string
  })
  default = {
    name        = "Plan101"
    description = "Usage plan for API Gateway"
  }
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
