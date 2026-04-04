output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = [for s in aws_subnet.private : s.id]
}

output "internet_gateway_id" {
  description = "Internet Gateway id"
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT Gateway id"
  value       = aws_nat_gateway.this.id
}
