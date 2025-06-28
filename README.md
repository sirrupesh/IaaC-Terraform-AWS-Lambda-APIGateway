# Infrastructure as Code (IaaC) - Lambda & API Gateway Project

This project demonstrates Infrastructure as Code using Terraform to deploy a complete serverless architecture with AWS Lambda and API Gateway. The Lambda function performs mathematical operations (addition) and is exposed via a RESTful API.

## Project Structure

```
IaaC-Terraform-AWS-Lambda-APIGateway/
├── main.tf                     # Main Terraform configuration
├── variables.tf                # Variable definitions
├── outputs.tf                  # Output definitions
├── create_lambda_package.sh    # Script to create Lambda deployment package
├── terraform.tfstate          # Terraform state file (auto-generated)
├── terraform.tfstate.backup   # Terraform state backup (auto-generated)
├── tfplan                     # Terraform plan file (auto-generated)
├── destroy-tfplan             # Terraform destroy plan (auto-generated)
├── modules/
│   ├── api_gateway/           # API Gateway module
│   │   ├── main.tf           # API Gateway resources
│   │   ├── variables.tf      # API Gateway variables
│   │   └── outputs.tf        # API Gateway outputs
│   ├── lambda/               # Lambda function module
│   │   ├── main.tf           # Lambda resources with alias support
│   │   ├── variables.tf      # Lambda variables
│   │   ├── outputs.tf        # Lambda outputs
│   │   ├── lambda_function.py # Python Lambda function code
│   │   └── lambda_code.zip   # Lambda deployment package
│   ├── iam/                  # IAM roles and policies module
│   │   ├── main.tf           # IAM resources
│   │   ├── variables.tf      # IAM variables
│   │   └── outputs.tf        # IAM outputs
│   └── api_keys/             # API keys and usage plans module
│       ├── main.tf           # API keys resources
│       ├── variables.tf      # API keys variables
│       └── outputs.tf        # API keys outputs
├── environments/             # Environment-specific configurations
│   └── prod.tfvars          # Production environment variables
└── generated-diagrams/       # Architecture diagrams
    └── api_gateway_migration_architecture.png.png
```

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later)
2. [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
3. Access to target AWS accounts.

## Setup Instructions

### 1. Create Lambda Deployment Package

Run the script to create the Lambda deployment package:

```bash
./create_lambda_package.sh
```

### 2. Configure AWS Credentials

Configure your AWS CLI with credentials for the target account. The default profile used is `my-rnd` (as defined in `prod.tfvars`):

```bash
aws configure --profile my-rnd
```

Or set your default profile and region:
```bash
export AWS_PROFILE=my-rnd
export AWS_DEFAULT_REGION=us-west-1
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the Deployment

```bash
terraform plan -var-file=environments/prod.tfvars -out=tfplan
```

### 5. Apply the Configuration

```bash
terraform apply tfplan
```

### 6. Clean Up Resources (When Needed)

To remove all resources created by this Terraform project:

```bash
# First, create a destroy plan to see what will be removed
terraform plan -destroy -var-file=environments/prod.tfvars -out=destroy-tfplan

# Review the plan carefully, then apply it to destroy resources
terraform apply destroy-tfplan
```

Alternatively, you can use the direct destroy command:

```bash
terraform destroy -var-file=environments/prod.tfvars
```

This will prompt for confirmation before removing all resources.

## Customization

### Environment Variables

You can customize the deployment by modifying variables in:

1. **Root Level**: `variables.tf` - Contains default values for all variables
2. **Environment Specific**: `environments/prod.tfvars` - Override defaults for specific environments

### Key Variables in `prod.tfvars`:

```terraform
# AWS Configuration
region = "us-west-1"
aws_profile = "my-rnd"

# API Gateway Configuration
api_name = "sample"
stage_name = "test"

# Lambda Configuration
lambda_function_name = "sample"
lambda_runtime = "python3.9"
lambda_memory_size = 128
lambda_timeout = 3

# Lambda Alias Configuration
lambda_alias_name = "QA-tested"
lambda_alias_description = "QA tested alias"

# API Keys Configuration
api_keys = [
  {
    name = "My-N8N API Key"
    description = "Used In N8N Workflow"
  },
  {
    name = "Rupesh-API-Key"
    description = "Used In Rupesh's Application"
  }
]
```

### Creating Additional Environments

To create additional environments (e.g., staging, dev):

1. Create new `.tfvars` files in the `environments/` directory
2. Customize variables for each environment
3. Deploy using: `terraform plan -var-file=environments/staging.tfvars`

## Resources Created

This Terraform project creates the following AWS resources:

### Core Infrastructure
1. **Lambda Function** (`sample`) - Python 3.9 runtime with mathematical operations
2. **Lambda Alias** (`QA-tested`) - For version management and deployment strategies
3. **API Gateway** (`sample`) - RESTful API with test stage
4. **IAM Role** (`My-AWSLambdaBasicExcutionRole`) - Execution role for Lambda function

### Security & Access Control
5. **IAM Policies** - Minimal required permissions for Lambda execution
6. **API Keys** - Two managed API keys:
   - `My-N8N API Key` - For N8N workflow integration
   - `Rupesh-API-Key` - For Rupesh's application
7. **Usage Plan** (`Plan101`) - Rate limiting and throttling configuration

### Monitoring & Management
8. **CloudWatch Logs** - Automatic log groups for Lambda function
9. **API Gateway Deployment** - Deployed to test stage
10. **Lambda Permissions** - API Gateway invoke permissions

## API Endpoints

Once deployed, the API Gateway will provide endpoints for:

- **POST** `<api_gateway_endpoint>/n8n/sum` - Main endpoint that triggers the Lambda function
- **Lambda Function**: Accepts JSON payload with two numbers and returns their sum

### 🔑 API Key Authentication Required

**Important**: All API endpoints require authentication using an API key. The endpoints are NOT publicly accessible.

#### How to Use API Keys:

1. **Retrieve API Key Values**: After deployment, get the API key values from AWS Console:
   - Go to AWS API Gateway Console
   - Navigate to "API Keys" section
   - Find your keys: `My-N8N API Key` or `Rupesh-API-Key`
   - Click "Show" to reveal the API key value

2. **Include API Key in Requests**: Add the API key to your HTTP requests using the `x-api-key` header:

#### Example API Call with Authentication:

```bash
curl -X POST https://your-api-gateway-url/test/n8n/sum \
  -H "Content-Type: application/json" \
  -H "x-api-key: YOUR_API_KEY_VALUE_HERE" \
  -d '{
    "num1": 1,
    "num2": 101
  }'
```

#### Example using Python:

```python
import requests
import json

url = "https://your-api-gateway-url/test/n8n/sum"
headers = {
    "Content-Type": "application/json",
    "x-api-key": "YOUR_API_KEY_VALUE_HERE"
}
data = {
    "num1": 1,
    "num2": 101
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

#### Example Request Payload:
```json
{
  "num1": 1,
  "num2": 101
}
```

#### Example Response:
```json
{
    "statusCode": 200,
    "headers": {
        "Content-Type": "application/json"
    },
    "body": "{\"result\": 102.0, \"num1\": 1.0, \"num2\": 101.0}"
}
```

#### Without API Key:
If you attempt to access the endpoint without an API key, you will receive:
```json
{
    "message": "Forbidden"
}
```

## Notes

### Lambda Function
- **Functionality**: The Lambda function (`lambda_function.py`) performs mathematical operations, specifically adding two numbers
- **Runtime**: Python 3.9 with structured logging
- **Versioning**: Automatic versioning enabled with `QA-tested` alias for deployment management
- **Dependencies**: No external dependencies required - uses only Python standard library

### API Keys & Security
- **🔒 Authentication Required**: All API endpoints require API key authentication via `x-api-key` header
- **API Keys**: Two API keys are created with new values upon deployment
- **Access Control**: Usage plans control rate limiting and access patterns
- **No Public Access**: Endpoints are protected and cannot be accessed without valid API keys
- **Key Management**: API key values must be retrieved from AWS Console after deployment

### Infrastructure Management
- **State Files**: Terraform state is maintained locally (`terraform.tfstate`)
- **Planning**: Use `tfplan` files to review changes before applying
- **Modular Design**: Each AWS service is in a separate module for maintainability

### Development Workflow
- **Local Development**: Lambda code can be modified in `modules/lambda/lambda_function.py`
- **Packaging**: Run `./create_lambda_package.sh` after code changes
- **Deployment**: Use environment-specific `.tfvars` files for different deployments

### Troubleshooting
- **AWS Credentials**: Ensure the `my-rnd` profile is configured or update `aws_profile` in `prod.tfvars`
- **Permissions**: Verify IAM permissions for Terraform to create/modify AWS resources
- **Region**: Default region is `us-west-1` - update in `prod.tfvars` if needed

## Architecture Overview

This project creates a serverless architecture with the following components:

- **AWS Lambda Function**: Python-based function that performs mathematical operations (adding two numbers)
- **Lambda Alias**: QA-tested alias for version management and deployment strategies
- **API Gateway**: RESTful API that exposes the Lambda function via HTTP endpoints
- **IAM Roles**: Secure execution roles for Lambda with minimal required permissions
- **API Keys**: Managed API keys with usage plans for access control
- **Usage Plans**: Rate limiting and throttling configurations

## Features

- **Modular Design**: Each AWS service is organized in separate Terraform modules
- **Environment Management**: Support for multiple environments via `.tfvars` files
- **Lambda Versioning**: Automatic versioning with alias support for blue/green deployments
- **Security**: IAM roles with least privilege access
- **API Management**: API keys and usage plans for controlled access
- **State Management**: Terraform state files for infrastructure tracking
