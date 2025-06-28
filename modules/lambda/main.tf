resource "aws_lambda_function" "function" {
  function_name = var.function_name
  description   = var.function_description
  role          = var.lambda_role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  
  # Use a local zip file for the Lambda code
  filename      = "${path.module}/lambda_code.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_code.zip")
  
  # Create a qualified alias for the function
  publish = true
}

# Create an alias for the Lambda function
resource "aws_lambda_alias" "qa_tested" {
  name             = var.lambda_alias_name
  description      = var.lambda_alias_description
  function_name    = aws_lambda_function.function.function_name
  function_version = aws_lambda_function.function.version
}
