#!/bin/bash

# Create a temporary directory
mkdir -p temp_lambda

# Copy the Lambda function code to the temporary directory
cp modules/lambda/lambda_function.py temp_lambda/lambda_function.py

# Ensure the target directory exists
mkdir -p modules/lambda

# Create a zip file
cd temp_lambda
zip -r ../modules/lambda/lambda_code.zip .
cd ..

# Clean up
rm -rf temp_lambda

echo "Lambda deployment package created at modules/lambda/lambda_code.zip"
