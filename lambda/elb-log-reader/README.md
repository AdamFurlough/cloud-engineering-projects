# ELB Log Reader
Reads ELB logs from an S3 bucket, unzips them, extract terms into json and sends to opensearch

## LINKS
- [AWS Tutorial I adapted](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/integrations.html#integrations-s3-lambda)
- [boto3 documentation](boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/put_object.html)
- [urllib3 error](https://urllib3.readthedocs.io/en/stable/v2-migration-guide.html#importerror-cannot-import-name-default-ciphers-from-urllib3-util-ssl)
- [s3 obj with boto3 error stackoverflow](https://stackoverflow.com/questions/31976273/open-s3-object-as-a-string-with-boto3)

## NOTES
- needs to create the function with an ENI inside the VPC containing OpenSearch domain
- need to create a new iam role with s3 and opensearch domain access

## INSTALL PIP
from the lambda dir...
```
pip install --target ./package requests
pip install --target ./package requests_aws4auth
```

## PACKAGE
...from the dir containing lambda_function.py and requirements.txt

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


## TROUBLESHOOTING
- if issues with urllib3
- make sure using older version compatible with botocore
- try clearing pip cashe ```pip cache purge```
