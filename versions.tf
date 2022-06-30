terraform {
  required_version = "~> 1.2.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }
  }

}
provider "aws" {
  region = var.region
}
