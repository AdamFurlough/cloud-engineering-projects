# VPC Endpoints

VPC endpoints allow resources within a VPC to directly access AWS services without traversing the public internet.

There are two different types of VPC endpoints, VPC Endpoint Gateways and VPC Endpoint Interface (ENI).

## VPC Endpoint Gateways

- Only used for access to S3 or DynamoDB services
- Must update route tables (no changes to SGs needed)
    - Destination: prefix list for S3 or DynamoDB (pl-12341234)
    - Target: vpc endpoint (vpce-123412341234)
- DNS resolution must be enabled
- Defined at the VPC level
- Cannot be extended beyond VPC (VPN, DX, TGW, peering does NOT work)

## VPC Endpoint Interface (ENI)

- ENI with private endpoint interface hostname
- Uses Security Groups
- Can be used for all services
- Private DNS (requires "Enable DNS hostnames" and "Enable DNS Support" = true)
    - Route 53 resolver example: (athena.us-east-1.amazonaws.com -> 10.0.0.10)
- DNS resolution and route tables needed
- Can be extended beyond VPC (VPN, DX, TGW, peering would work)

## Policies

- Can be attached to both types: VPC Endpoint Gateways (S3 & DynamoDB only) and VPC Endpoint Interface (ENI)
- Still also allow by IAM, bucket policies, etc.