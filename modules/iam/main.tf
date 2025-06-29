resource "aws_iam_role" "lambda_role" {
  name        = var.role_name
  description = var.role_description
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = var.tags
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "lambda_execute" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_policy_arn
}
