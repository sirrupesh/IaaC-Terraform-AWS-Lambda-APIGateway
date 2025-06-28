region = "us-west-1"
aws_profile = "my-rnd"  # Change this to your target account profile

# API Gateway variables
api_name        = "sample"
api_description = "This is a sample API Gateway"
stage_name      = "test"

# Lambda variables
lambda_function_name = "sample"
lambda_description   = "This is a sample Lambda function that will be used in the API Gateway to add two numbers."
lambda_handler       = "lambda_function.lambda_handler"
lambda_runtime       = "python3.9"
lambda_memory_size   = 128
lambda_timeout       = 3

# Lambda Alias variables
lambda_alias_name        = "QA-tested"
lambda_alias_description = "QA tested alias"

# IAM variables
lambda_role_name        = "My-AWSLambdaBasicExcutionRole"
lambda_role_description = "Allows Lambda functions to call AWS services on your behalf."

# API Keys and Usage Plan variables
api_keys = [
  {
      name        = "My-N8N API Key"
      description = " Used In N8N Workflow"
    },
    {
      name        = "Rupesh-API-Key"
      description = " Used In Rupesh's Application"
    }
]

usage_plan = {
    name        = "Plan101"
    description = "Usage plan for API Gateway"
  }
