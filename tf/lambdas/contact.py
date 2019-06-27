import json
import os
import urllib

import boto3


def handler(event, context):
    print(type(event))
    print(event)
    try:
        data = json.loads(event['body'])
    except json.decoder.JSONDecodeError:
        data = dict(urllib.parse.parse_qsl(event['body']))

    for required_key in ('email', 'text'):
        if required_key not in data:
            return {'statusCode': '400'}

    subject = os.environ['MessageSubject'].format(email=data['email'], name=data.get('name'))
    body = os.environ['MessageBody'].format(text=data['text'], name=data.get('name'))

    payload = {
        'Source': os.environ['SenderAddress'],
        'Destination': {'ToAddresses': [os.environ['RecipientAddress']]},
        'ReplyToAddresses': [data['email']],
        'Message': {
            'Subject': {
                'Charset': 'UTF-8',
                'Data': subject
            },
            'Body': {
                'Text': {
                    'Charset': 'UTF-8',
                    'Data': body
                }
            }

        }
    }

    boto3.client('ses', region_name='us-west-2').send_email(**payload)
    return {
        'statusCode': '201',
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token',
            'Access-Control-Allow-Methods': 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT',
            'Access-Control-Allow-Origin': '*'
        },
    }
