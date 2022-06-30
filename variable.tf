variable "region" {
  description = "AWS Region in which the vpc is required to create"
  validation {
    condition = (
      can(regex("^us-", var.region))
    )
    error_message = "The regions value must start with \"us-\"."
  }
}

variable "vpc_cidr" {
  description = "CIDR range of VPC"
}

variable "subnet_cidr_a" {
  description = "CIDR of subnet a within a VPC"
  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_a))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "subnet_cidr_b" {
  description = "CIDR of private nated subnet a within a VPC"
  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_b))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "subnet_cidr_c" {
  description = "CIDR of private isolated subnet a within a VPC"
  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_c))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "environment" {
  description = "Environment to be used"
  //  default = "prod" Could use different vars file like prod.tfvars or stg.tfvars to make it more scalable
}