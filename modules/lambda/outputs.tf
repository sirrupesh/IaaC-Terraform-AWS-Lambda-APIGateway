output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.function.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.function.invoke_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.function.function_name
}

output "lambda_qualified_arn" {
  description = "ARN of the Lambda function with alias"
  value       = aws_lambda_alias.qa_tested.arn
}

output "lambda_qualified_invoke_arn" {
  description = "Invoke ARN of the Lambda function with alias"
  value       = aws_lambda_alias.qa_tested.invoke_arn
}
