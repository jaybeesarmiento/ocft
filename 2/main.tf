terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }

  backend "s3" {
    bucket = "terraform-bucket"
    key    = "test/.tfstate"
    region = "ap-southeast-1"
  }

}
variable "AWS_REGION" {
  default = "ap-northeast-2"
}

# Configure the AWS Provider
provider "aws" {
  region = var.AWS_REGION
}

