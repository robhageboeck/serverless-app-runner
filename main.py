import gradio as gr
import boto3
import os
import json
from datetime import datetime
import dotenv

def serverAddr():
    return None if os.getenv('ENVIRONMENT') != 'production' else '0.0.0.0'

def setupLocalClient():
    dotenv.load_dotenv()
    boto3.setup_default_session(profile_name=os.getenv('AWS_PROFILE'), region_name=os.getenv('AWS_REGION'))

def client(service):
    if os.getenv('ENVIRONMENT') != 'production':
      setupLocalClient()
    return boto3.client(service)

def log_name(name):
    s3 = client('s3')
    bucket_name = f'serverless-app-runner-logs-{os.getenv("STAGE")}'

    log_entry = {
        'name': name,
        'timestamp': datetime.utcnow().isoformat()
    }
    
    object_key = f"logs/{datetime.utcnow().isoformat()}.json"
    
    s3.put_object(
        Bucket=bucket_name,
        Key=object_key,
        Body=json.dumps(log_entry),
        ContentType='application/json'
    )

def greet(name):
    log_name(name)
    return "Hello " + name + "!"

if __name__ == "__main__":
    iface = gr.Interface(fn=greet, inputs="text", outputs="text")
    iface.launch(server_name=serverAddr(), server_port=8080, show_error=True)
