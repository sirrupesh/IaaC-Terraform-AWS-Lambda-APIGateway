terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use a compatible version
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
  # Target account credentials will be configured via AWS CLI profiles or environment variables
}

module "api_gateway" {
  source = "./modules/api_gateway"
  
  api_name        = var.api_name
  api_description = var.api_description
  stage_name      = var.stage_name
  
  # Pass the Lambda function ARN from the Lambda module
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_qualified_arn = module.lambda.lambda_qualified_arn
  lambda_function_name = module.lambda.lambda_function_name
  lambda_alias_name = var.lambda_alias_name
  
  # Path parts for API resources
  primary_resource_path = var.primary_resource_path
  secondary_resource_path = var.secondary_resource_path
}

module "lambda" {
  source = "./modules/lambda"
  
  function_name        = var.lambda_function_name
  function_description = var.lambda_description
  handler              = var.lambda_handler
  runtime              = var.lambda_runtime
  memory_size          = var.lambda_memory_size
  timeout              = var.lambda_timeout
  
  # Lambda alias configuration
  lambda_alias_name        = var.lambda_alias_name
  lambda_alias_description = var.lambda_alias_description
  
  # Pass the IAM role ARN from the IAM module
  lambda_role_arn = module.iam.lambda_role_arn
}

module "iam" {
  source = "./modules/iam"
  
  role_name        = var.lambda_role_name
  role_description = var.lambda_role_description
  tags             = var.tags
  lambda_policy_arn = var.lambda_policy_arn
}

module "api_keys" {
  source = "./modules/api_keys"
  
  api_keys       = var.api_keys
  usage_plan     = var.usage_plan
  api_id         = module.api_gateway.api_id
  api_stage_name = module.api_gateway.stage_name
  api_key_enabled = var.api_key_enabled
  throttle_settings = var.throttle_settings
  quota_settings = var.quota_settings
}
