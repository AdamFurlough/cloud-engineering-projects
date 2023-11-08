# Set Up Kinesis Data Firehose

   **Goal:** set up a Kinesis Data Firehose delivery stream to receive data from Fluent Bit running on an EC2 instance and send the data to OpenSearch:

1. Create a Kinesis Data Firehose Delivery Stream
   * Go to the AWS Management Console and navigate to the 
   * Kinesis Data Firehose service.
   * Click on "Create delivery stream".
   * Choose a name for your delivery stream and select "Direct PUT or other sources" as the source.
   * Click "Next".

2. Configure the delivery stream
   * Select "Amazon OpenSearch Service" as the destination.
   * Select the OpenSearch domain you want to use as the destination.
   * Choose the index and type name for the documents.
   * Select the KMS key that you want to use to encrypt the data.
   * Click "Next".

3. Configure the data transformation
   * Under "Record transformation", choose "Enabled".
   * Choose "Convert record format" and select "Choose a processor".
   * Select "Fluent Bit" as the processor and configure the processor with the following settings:
       * Endpoint: localhost:24224 (assuming Fluent Bit is running on the same EC2 instance)
       * Data format: JSON
   * Click "Next".

4. Configure the S3 backup
   * If you want to back up your data to S3, select "Enabled".
   * Choose the S3 bucket and prefix for the backup data.
   * Click "Next".

5. Review and create the delivery stream
   * Review your settings and click "Create delivery stream".
   * Wait for the delivery stream to become active.
   6. Configure Fluent Bit to send data to the delivery stream
