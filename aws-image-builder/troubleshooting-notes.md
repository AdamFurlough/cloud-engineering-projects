# Troubleshooting Notes

## Why isn't temp EC2 automatically terminating when complete?

likely because the workflow failed to complete

## To Debug

1. Go to EC2  Instances, find the Image Builder EC2 instance that failed.
2. Connect via Session Manager or SSH if needed (you can enable SSH in the infrastructure config).
3. Inspect logs under
    varlogimagebuilder
    varlogcloud-init.log
    varlogcloud-init-output.log
4. Check the Build Logs from the Image Builder pipeline execution screen (via Console or CLI)
    - These include component-level details and exit codes.
5. Validate your build components YAML and test them in a manual EC2 build if needed.