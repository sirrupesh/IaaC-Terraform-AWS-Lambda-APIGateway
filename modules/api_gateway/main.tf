# Get current AWS region
data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_description
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Root resource is created automatically
resource "aws_api_gateway_resource" "n8n" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "n8n"
}

resource "aws_api_gateway_resource" "sum" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.n8n.id
  path_part   = "sum"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.sum.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.sum.id
  http_method = aws_api_gateway_method.post.http_method
  
  integration_http_method = "POST"
  type                    = "AWS"
  # Use the correct format for Lambda alias integration
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_qualified_arn}/invocations"
  
  passthrough_behavior = "WHEN_NO_MATCH"
  content_handling     = "CONVERT_TO_TEXT"
  timeout_milliseconds = 29000
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.sum.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.sum.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.n8n.id,
      aws_api_gateway_resource.sum.id,
      aws_api_gateway_method.post.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [
    aws_api_gateway_method.post,
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage_name
}

# Lambda permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  qualifier     = var.lambda_alias_name
  principal     = "apigateway.amazonaws.com"
  
  # The source ARN is the API Gateway ARN
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/${aws_api_gateway_method.post.http_method}${aws_api_gateway_resource.sum.path}"
}
