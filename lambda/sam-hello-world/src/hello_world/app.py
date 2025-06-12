import json

def lambda_handler(event, context):
    """
    Simple Lambda function that returns a greeting
    
    :param event: AWS Lambda uses this to pass in event data
    :param context: Runtime information provided by AWS Lambda
    :return: JSON response with greeting
    """
    name = event.get('name', 'World')
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': f'Hello, {name}! Welcome to AWS Lambda with SAM.'
        })
    }
