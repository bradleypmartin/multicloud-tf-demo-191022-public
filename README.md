# multicloud-demo-2019

This repo contains Terraform code to support a multi-cloud HTTP server demo with HashiCorp tools. This demo was presented at an Ibotta Tech Lunch and Learn session in October 2019.

## Overview

The Terraform modules `aws_deployment`, `azure_deployment`, and `gcp_deployment` contain resource definitions for HTTP server deployments in their respective cloud providers.

If you would like to try out one or more of the deployments herein, please see the sections below regarding requirements for each provider.

Each deployment assumes you have _some_ way to `plan` and `apply` Terraform code...whether that's locally or through a remote service like Terraform Cloud/Enterprise. HashiCorp offers [some helpful documentation](https://learn.hashicorp.com/terraform) to get you started.

Finally, the `consul.d` folder here contains example service configurations for a 'first crack' at running a local Consul agent to keep track of the multicloud deployment shared here. I followed the [HashiCorp Learn docs](https://learn.hashicorp.com/consul) to get going with Consul.

The `consul.d` folder also has a few notes on how I set up and tried out Consul locally (in a separate README within the folder).

## AWS deployment

To try out the AWS deployment, you'll need an AWS account, along with appropriate IAM permissions to create and modify infrastructure through Terraform.

I created an admin-level IAM User and stored the User's access key and secret key in the Terraform Cloud `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` Environment Variables, respectively. You could also use these keys along with the `$ aws configure` command to set yourself up to do local `plan` and `apply` steps with your Terraform code.

## Azure deployment

In the Azure portal, I created a Service Principal to help execute my Terraform commands.

First, in an Azure `bash` session (reached directly from the Azure Portal), I executed the following to get the `ARM_SUBSCRIPTION_ID` and `ARM_TENANT_ID` that I'd enter as Terraform Cloud Environment Variables:

```
$ az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
```

Next, I entered the following into the shell to create my Service Principal:

```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<INSERT_SUB_ID_HERE>"
```

The `appId` and `password` output from the console here were put into the `ARM_CLIENT_ID` and `ARM_CLIENT_SECRET` Environment Variables in Terraform Cloud, respectively.

With the above four Variables configured, I could start making deployments to Azure via Terraform Cloud. Configuration may vary somewhat if executing `plan` and `apply` steps to Azure from a local machine (I haven't tried this).

## GCP Deployment

In the GCP console, I first set up a `Project`, and then enabled the Compute Engine API within that project.

Within the new `Project`, I set up Service Account credentials via `APIs and Services -> Credentials`. This gave me a JSON file that I could insert as one _big_ string (carefully trimming newlines) into the `GOOGLE_CLOUD_KEYFILE_JSON` Environment Variable in Terraform Cloud.

Next, I made a new SSH key in my local machine's terminal and added the _public_ key into `Compute Engine -> Metadata (SSH Keys tab)` in the format `ssh-rsa <public key> <username>`.

I had to then SSH into the compute instance created by Terraform and manually create a simple Flask app in an `app.py` file. The file's contents are entirely given below (remembering that we installed Flask via the bootstrap script in Terraform):

```
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_cloud():
   return 'Hello Tech Talk Attendees from GCP!'

app.run(host='0.0.0.0')
```

Finally, I installed `tmux` and started the Flask up in the background with the following:

```
$ tmux new -d -s web-app-session 'python app.py'
```
