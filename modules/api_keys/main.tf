resource "aws_api_gateway_api_key" "keys" {
  for_each    = { for key in var.api_keys : key.name => key }
  
  name        = each.value.name
  description = each.value.description
  enabled     = true
}

resource "aws_api_gateway_usage_plan" "plan" {
  name        = var.usage_plan.name
  description = var.usage_plan.description
  
  api_stages {
    api_id = var.api_id
    stage  = var.api_stage_name
  }
  
  # Add throttling and quota settings
  throttle_settings {
    burst_limit = 20
    rate_limit  = 10
  }
  
  quota_settings {
    limit  = 1000
    period = "MONTH"
  }
}

resource "aws_api_gateway_usage_plan_key" "plan_keys" {
  for_each      = aws_api_gateway_api_key.keys
  
  key_id        = each.value.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.plan.id
}
