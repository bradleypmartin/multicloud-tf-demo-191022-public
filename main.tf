provider "aws" {
  region  = "us-east-1"
  version = "~> 2.32"
}

provider "azurerm" {
  version = "~> 1.27"
}

provider "google" {
  project = "<google project name>"
  region  = "us-west1"
  version = "~> 2.17"
}

module "aws_deployment" {
  source = "./aws_deployment"
}

module "azure_deployment" {
  source = "./azure_deployment"
}

module "gcp_deployment" {
  source = "./gcp_deployment"
}
