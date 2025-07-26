# Step: Apply Build Components

`ApplyBuildComponents` is usually the second step in an image builder pipeline. (With `LaunchBuildInstance` being the first.)

## Step Input

The Step Input document contains a JSON section that looks something like this:

```json
{
  "components": [
    {
      "arn": "arn:aws:imagebuilder:us-east-1:123456789012:component/my-install@1.0.0/1",
      "name": "my-install",
      "parameters": {}
    },
    {
      "arn": "arn:aws:imagebuilder:us-east-1:aws:component/update-linux@1.0.0/1",
      "name": "update-linux"
    }
  ]
}
```

This is a list of components that will be executed one-by-one as the `ApplyBuildComponents` step runs. This JSON list drives the actual execution of the component commands in the EC2 build instance.