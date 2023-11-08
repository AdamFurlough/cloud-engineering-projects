# RHEL EC2 Instance with SSM Agent and Session Manager Connection Tutorial

This tutorial will guide you through the process of creating a new RHEL EC2 instance with the SSM Agent installed and show you how to connect to the instance using AWS Session Manager. We'll also cover common mistakes and resolutions that may prevent you from connecting to the instance.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Creating a RHEL EC2 Instance](#creating-a-rhel-ec2-instance)
3. [Installing the SSM Agent](#installing-the-ssm-agent)
4. [Connecting to the Instance using Session Manager](#connecting-to-the-instance-using-session-manager)
5. [Common Mistakes and Resolutions](#common-mistakes-and-resolutions)

## Prerequisites <a name="prerequisites"></a>

Before we get started, make sure you have the following:

- An AWS account with appropriate permissions to create EC2 instances and use AWS Systems Manager.
- AWS CLI installed and configured on your local machine.

## Creating a RHEL EC2 Instance <a name="creating-a-rhel-ec2-instance"></a>

1. Sign in to the AWS Management Console and open the EC2 Dashboard.

2. Click **Launch Instance** and select the RHEL AMI (Amazon Machine Image) of your choice.

3. Choose an instance type that meets your requirements and click **Next**.

4. Configure the instance details. Make sure to enable the "Auto-assign Public IP" option for easier connectivity.

5. Add storage and tags as needed.

6. Configure the security group to allow the necessary traffic. For this tutorial, ensure that the security group allows inbound traffic on port 22 (SSH) and port 80 (HTTP) from your IP address.

7. Review your instance settings and click **Launch**.

8. Select an existing key pair or create a new one, then click **Launch Instances**.

Your RHEL EC2 instance will now be created.

## Installing the SSM Agent <a name="installing-the-ssm-agent"></a>

1. Connect to your RHEL instance using SSH.

2. Update the packages:

```
sudo yum update -y
```

3. Install the SSM Agent:

```
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
```

4. Check that agent is running
```
sudo systemctl status amazon-ssm-agent
```

In the rare case that output says it is NOT running, Start and enable the SSM Agent service

```
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
```

The SSM Agent is now installed on your RHEL instance.

## Connecting to the Instance using Session Manager <a name="connecting-to-the-instance-using-session-manager"></a>

1. Open the AWS Systems Manager console.

2. In the navigation pane, choose **Session Manager**.

3. Click **Start session**.

4. In the **Instance** list, select the RHEL instance you created earlier, and click **Start session**.

You are now connected to your RHEL instance using AWS Session Manager.

## Common Mistakes and Resolutions <a name="common-mistakes-and-resolutions"></a>

Here are some common mistakes that might prevent you from connecting to your RHEL instance using Session Manager:

### 1. IAM Role is not assigned to the instance

The EC2 instance must have an IAM role with the necessary permissions to use the SSM Agent and Session Manager.

#### Resolution

Create an IAM role with the `AmazonSSMManagedInstanceCore` policy attached and associate it with the EC2 instance.

### 2. SSM Agent is not running

The SSM Agent must be running on the instance to enable Session Manager connectivity.

#### Resolution

Make sure the SSM Agent is installed and running on the instance. Follow the steps in the [Installing the SSM Agent](#installing-the-ssm-agent) section to ensure the agent is correctly set up.

### 3. Instance is not reachable due to Security Group configuration

The security group attached to the instance might have rules that prevent connectivity.

#### Resolution

Review the security group rules and ensure that the necessary traffic is allowed. For this tutorial, make sure the security group allows inbound traffic on port 22 (SSH) and port 80 (HTTP) from your IP address. Additionally, ensure that the security group allows outbound traffic to the internet.

### 4. SSM Agent is outdated

An outdated SSM Agent might cause connectivity issues with Session Manager.

#### Resolution

Update the SSM Agent on your RHEL instance:

```bash
sudo yum update -y amazon-ssm-agent
```

Then restart the agent:

```bash
sudo systemctl restart amazon-ssm-agent
```

### 5. Session Manager Plugin is not installed on the local machine

The Session Manager Plugin is required for using the AWS CLI to start sessions.

#### Resolution

Download and install the Session Manager Plugin for your platform by following the instructions in the [official AWS documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).

Once you've addressed any issues that might have been preventing connectivity, try connecting to your RHEL instance using Session Manager again. If you still encounter issues, review the [official AWS documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-troubleshooting.html) for additional troubleshooting steps.
