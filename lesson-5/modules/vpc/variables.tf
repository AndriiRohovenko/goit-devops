variable "vpc_cidr_block" {
  description = "VPC network range (CIDR), for example 10.0.0.0/16"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs (3 items)"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs (3 items)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets (same count/order as subnets)"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name used in AWS tags"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames (usually keep true)"
  type        = bool
  default     = true
}
