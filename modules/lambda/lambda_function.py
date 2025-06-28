import json
import logging

# Configure logging Test
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function to add two numbers.
    
    Parameters:
    - event: Contains the input data from the API Gateway
    - context: Contains runtime information
    
    Returns:
    - JSON response with the sum of the two numbers
    """
    # Log the entire event object
    logger.info("Received event: %s", json.dumps(event))
    
    try:
        # Check if the input is directly in the event (Lambda console testing)
        # or in the body property (API Gateway)
        if event.get('body') is not None:
            # API Gateway integration - parse the body
            if isinstance(event['body'], str):
                body = json.loads(event['body'])
            else:
                body = event['body']  # In case body is already parsed
            logger.info("Parsed body from API Gateway: %s", json.dumps(body))
        else:
            # Direct Lambda invocation - use event as body
            body = event
            logger.info("Using direct event as body: %s", json.dumps(body))
        
        # Extract the two numbers from the request
        num1 = body.get('num1')
        num2 = body.get('num2')
        
        # Validate input
        if num1 is None or num2 is None:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({
                    'error': 'Both num1 and num2 are required'
                })
            }
        
        # Convert to numbers if they're strings
        try:
            num1 = float(num1)
            num2 = float(num2)
        except (ValueError, TypeError):
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json'
                },
                'body': json.dumps({
                    'error': 'num1 and num2 must be valid numbers'
                })
            }
        
        # Calculate the sum
        result = num1 + num2
        
        # Return the result
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'result': result,
                'num1': num1,
                'num2': num2
            })
        }
    
    except Exception as e:
        # Handle any unexpected errors
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }