output "api_key_ids" {
  description = "IDs of the created API keys"
  value       = { for k, v in aws_api_gateway_api_key.keys : k => v.id }
}

output "usage_plan_id" {
  description = "ID of the created usage plan"
  value       = aws_api_gateway_usage_plan.plan.id
}
