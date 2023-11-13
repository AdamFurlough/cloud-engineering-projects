#!/bin/bash
today=`date "+%Y%m%d"`
echo $today

# Set the OpenSearch domain and index
OPENSEARCH_URL=add_opensearch_domain_endpoint_url_here
INDEX_NAME=add_index_name_here

# Set the S3 bucket and prefix for the dump files output
BUCKET=add_bucket_name_here
DUMP_PREFIX=test_script_files

# Set default region and access key
export AWS_DEFAULT_REGION=add_region_here
export AWS_ACCESS_KEY_ID=add_key_id_here
export AWS_SECRET_ACCESS_KEY=add_key_here

echo "Dumping data..."
elasticdump \
  --awsAccessKeyId=$AWS_ACCESS_KEY_ID \
  --awsSecretAccessKey=$AWS_SECRET_ACCESS_KEY \
  --input=$OPENSEARCH_URL/$INDEX_NAME \
  --output=$DUMP_PREFIX-data-$today.json \
  --type=data

echo "Dumping mapping..."
elasticdump \
  --awsAccessKeyId=$AWS_ACCESS_KEY_ID \
  --awsSecretAccessKey=$AWS_SECRET_ACCESS_KEY \
  --input=$OPENSEARCH_URL/$INDEX_NAME \
  --output=$DUMP_PREFIX-mapping-$today.json \
  --type=mapping

echo "Uploading to S3 bucket: $BUCKET"
aws s3 cp $DUMP_PREFIX-mapping-$today.json s3://$BUCKET/
aws s3 cp $DUMP_PREFIX-data-$today.json s3://$BUCKET/

echo "Purging the dump files..."
rm -rf $DUMP_PREFIX*.json
echo "Done!"
