variable "role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role for Lambda"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}

variable "lambda_policy_arn" {
  description = "ARN of the policy to attach to the Lambda role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
