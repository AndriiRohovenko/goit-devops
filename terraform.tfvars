bucket_name = "andrii-goit-terraform-state-lesson-5"
aws_region  = "eu-central-1"
backend_force_destroy = true
table_name  = "terraform-locks"

vpc_cidr_block     = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
vpc_name           = "lesson-5-vpc"

ecr_name     = "lesson-5-ecr"
scan_on_push = true
