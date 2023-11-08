# AWS OPENSEARCH SETUP

Goal: setup a simple demo opensearch domain with example data to support other experimentation

## Links

- [Original Tutorial I followed](https://github.com/johnny-chivers/amazon-opensearch-service) and [Accompanying Video](https://www.youtube.com/watch?v=SIl5PM4m2KM)
- [Video on maping IAM roles to OpenSearch roles](https://www.youtube.com/watch?v=KeUBwm-aalU)
- https://opensearch.org/docs/latest/security/access-control/users-roles/

## Tutorial

1. Navigate to the OpenSearch page in AWS console and click "Create domain"
2. On the create domain page...
    * Enter a name for the domain ***labdomain***
    * In "Domain creation method" select "standard create"
    * In "Templates" select "Dev/test"
    * In "Deployment Option(s)" select "Domain without standby" and "1-AZ"
    * In "Engine options" leave default for latest
    * In "Data nodes" select instance type and set number of nodes to "1" *(note: the "t" family of instances does not support encryption and therefore won't support fine-grained access controls, m5.large.search is the cheapest that will work for these tests, it is currently $0.142 per hour)*
    * Skip down to "Network" and select "Public access"
    * In "Fine-grained access control" select "create master user" ***admin, 
    TurtleJump1!***
    * In "Access policy" select "only use fine-grain access control"
    * Create, then wait 10-15 min for create to finish

2. Upload Documents

    *  To upload multiple documents, create a json file and upload
        ```
        curl -XPOST -u 'admin:TurtleJump1!' 'https://search-lab-opensearch-domain-v2jikoe3kstgl22nrcauznci4u.us-east-1.es.amazonaws.com/_bulk' --data-binary @bulk_movies.json -H 'Content-Type: application/json'
        ```
