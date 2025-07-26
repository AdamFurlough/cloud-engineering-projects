# CloudWatch Logs Insights

This dir contains handy cwl insights for quick reference.

The code blocks are labeled as sql for colored syntax highlighting even though in reality, the language used in CloudWatch Logs Insights is a proprietary query language developed by AWS and is not based on SQL or any general-purpose language. It is often referred to informally as the CloudWatch Logs Insights Query Language but is also known as CloudWatch Logs Insights query syntax.

## Language Characteristics

- Structured but simple, optimized for speed and readability.
- Uses pipe (|) chaining, similar to shell scripting or tools like jq, awk, or PowerShell.
- Supports basic operations:
    - fields, filter, sort, limit
    - Regular expressions and parsing with parse
    - Aggregations with stats, count, avg, sum, etc.
