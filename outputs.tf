output "api_gateway_id" {
  description = "ID of the created API Gateway"
  value       = module.api_gateway.api_id
}

output "api_gateway_endpoint" {
  description = "Endpoint URL of the API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value       = module.lambda.lambda_arn
}

output "lambda_function_name" {
  description = "Name of the created Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_role_arn" {
  description = "ARN of the created IAM role for Lambda"
  value       = module.iam.lambda_role_arn
}

output "api_keys" {
  description = "Created API keys"
  value       = module.api_keys.api_key_ids
  sensitive   = true
}

output "usage_plan_id" {
  description = "ID of the created usage plan"
  value       = module.api_keys.usage_plan_id
}
