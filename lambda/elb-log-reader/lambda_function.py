import boto3
import re
import requests
import gzip
from requests_aws4auth import AWS4Auth
from botocore.response import StreamingBody

region = 'us-gov-west-1'
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

host = 'https://add_opensearch_domain_here.us-west-1.es.amazonaws.com' # the OpenSearch Service domain
index = 'my-elb-logs'
datatype = '_doc'
url = host + '/' + index + '/' + datatype

headers = { "Content-Type": "application/json" }

# create a client object for s3 using boto
s3 = boto3.client('s3')

# regular expression pattern for ELB logs
elb_log_pattern = re.compile(
    r'(?P<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}Z)\s'
    r'(?P<elb_name>[^\s]+)\s'
    r'(?P<client_ip_port>[^\s]+)\s'
    r'(?P<backend_ip_port>[^\s]+)\s'
    r'(?P<request_processing_time>[^\s]+)\s'
    r'(?P<backend_processing_time>[^\s]+)\s'
    r'(?P<response_processing_time>[^\s]+)\s'
    r'(?P<elb_status_code>\d{3})\s'
    r'(?P<backend_status_code>\d{3})\s'
    r'(?P<received_bytes>\d+)\s'
    r'(?P<sent_bytes>\d+)\s'
    r'"(?P<request>[^"]+)"\s'
    r'"(?P<user_agent>[^"]+)"\s'
    r'(?P<ssl_cipher>[^\s]+)\s'
    r'(?P<ssl_protocol>[^\s]+)\s'
    r'(?P<target_group_arn>[^\s]+)\s'
    r'"(?P<trace_id>[^"]+)"'
)

# Lambda execution starts here
def lambda_handler(event, context):
    for record in event['Records']:
        
        # Get the bucket name and object key from trigger record
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Get and read the file
        obj = s3.get_object(Bucket=bucket, Key=key)
        
        # Capture bytestream from raw object zip
        bytestream = StreamingBody(raw_stream=obj['Body'], content_length=int(obj['ContentLength']))

        # Decompress on-the-fly and process lines
        with gzip.GzipFile(fileobj=bytestream) as gz:
            for line in gz:
                line = line.decode("utf-8").strip()

                elb_match = elb_log_pattern.search(line)

                if elb_match:
                    document = elb_match.groupdict()
                    print("Successfully unzipped the log file, matched the regular expressions to each line, and indexed the JSON")
                    
                    r = requests.post(url, auth=awsauth, json=document, headers=headers)
                    print("Successfully sent to opensearch")
                else:
                    print(f"Failed to match ELB log line: {line}")
