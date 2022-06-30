environment = "prod"
region      = "us-east-1"
vpc_cidr    = "10.10.10.0/24" // 256 ips
// Divided CIDR in to 3 subnets to use maximum use of ips.
subnet_cidr_a = "10.10.10.0/26"
subnet_cidr_b = "10.10.10.64/26"
subnet_cidr_c = "10.10.10.128/26"