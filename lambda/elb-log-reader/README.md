# Lambda, ELB Logs from S3
- Purpose: reads ELB logs from an S3 bucket, unzips them, extract terms into json and sends to opensearch
- [based on this AWS Tutorial](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/integrations.html#integrations-s3-lambda)

## PREREQUISITES
- create the function with an ENI inside the VPC containing OpenSearch domain
- create a new iam role with s3 and opensearch domain access
- make sure security group allows access to the OpenSearch domain and the S3 endpoint
    - to allow access to the S3 endpoint create an outbound HTTPS rule in your security group with the VPC endpoint prefix as your destination, e.g. pl-xxxx
    - You can get the endpoint prefix in the AWS console via VPC --> Managed Prefix Lists --> prefix that points to S3

## PACKAGE USING PIP
from the dir containing lambda_function.py and requirements.txt, run these commands:

```
pip install -r requirements.txt -t package/
cd package
zip -r ../lambda.zip .
cd ..
zip -g lambda.zip lambda_function.py
```

## EXPLANATION OF PACKAGING
- The command zip -g lambda.zip sample.py uses the zip utility to add the sample.py file to an existing ZIP archive named lambda.zip.
- The -g option indicates that the file should be "grown" into the ZIP archive, meaning the file is added to the existing ZIP without recompressing the entire archive.
- This can be faster than creating a new ZIP file and adding all the files again, especially if the existing ZIP archive is large.

## TROUBLESHOOTING BOTO3
- [boto3 documentation](boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/put_object.html)
- [s3 obj with boto3 error stackoverflow](https://stackoverflow.com/questions/31976273/open-s3-object-as-a-string-with-boto3)

## TROUBLESHOOTING DEPENDENCY VERSIONS
- note that boto3 is only compatible with an older version of urllib3
- if you try to use the latest urllib3 will get this error:
```[ERROR] Runtime.ImportModuleError: Unable to import module 'lambda_function': cannot import name 'DEFAULT_CIPHERS' from 'urllib3.util.ssl_' (/var/task/urllib3/util/ssl_.py) Traceback (most recent call last):```
- [read about reccomended way to pin older version of urllib3 here](https://urllib3.readthedocs.io/en/stable/v2-migration-guide.html#importerror-cannot-import-name-default-ciphers-from-urllib3-util-ssl)
- can clearing pip cashe ```pip cache purge``` and rerun above packaging instructions, double check that older version of urllib3 (like urllib3-1.26.18.dist-info) is packaged
