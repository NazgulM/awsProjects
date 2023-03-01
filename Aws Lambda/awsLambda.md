# Creating AWS Lambda Function

Go to S3--> Create bucket--> add Bucket name --> have to remember the region , it should use in AWS Lambda function
Create lambda function --> give it name --> Author from scratch--> for runtime choose python 3.9 --> permission can see that if lambda running this code it also can upload logs to Amazon CloudWatch.
Then change default execution role --> create a new role from AWs policy templates --> choose Amazon S3 object read-only permissions

After creating the lambda function put in existing json file following code

```
import json
import urllib.parse
import boto3

print('Loading function)

s3=boto3.client('s3')

def lambda_handler(event, context):
    #print("Received event: " +json.dumps(event, indent=2))

    #Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    try: 
       response = s3.get_object(Bucket=bucket, Key=key)
       print("CONTENT TYPE: " + response['ContentType'])
       return response['ContentType']
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function. ' .format(key, bucket))
        raise e

```

Then have to deploy, piece of code that triggered by something, then in Function overview list click add-trigger , and add you s3 bucket, they can work together. 
Then go back to your S3 bucket, let's click upload, and upload image, it should trigger lambda function, 

