terraform {
  required_version = "~> 1.2.3"

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
//  // length(var.region) > 0 && substr(var.region, 0, 2) == "us-"