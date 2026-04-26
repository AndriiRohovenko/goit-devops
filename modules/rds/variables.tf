variable "name" {
  description = "Name prefix used for the RDS instance or Aurora cluster"
  type        = string
}

variable "use_aurora" {
  description = "If true, create an Aurora cluster instead of a standard RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Engine for a standard RDS instance"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for a standard RDS instance"
  type        = string
  default     = "17.2"
}

variable "parameter_group_family_rds" {
  description = "Parameter group family for a standard RDS instance"
  type        = string
  default     = "postgres17"
}

variable "engine_cluster" {
  description = "Engine for Aurora clusters"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Engine version for Aurora clusters"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_aurora" {
  description = "Parameter group family for Aurora clusters"
  type        = string
  default     = "aurora-postgresql15"
}

variable "aurora_instance_count" {
  description = "Total number of Aurora instances including the writer"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB for a standard RDS instance"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC id where the database security group is created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR used as a safe default for database ingress"
  type        = string
}

variable "subnet_private_ids" {
  description = "Private subnet ids for the database"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Public subnet ids for the database when it is public"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ for a standard RDS instance"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot during destroy"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the database port"
  type        = list(string)
  default     = []
}

variable "parameters" {
  description = "Map of database parameters applied to the parameter group"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to all created resources"
  type        = map(string)
  default     = {}
}