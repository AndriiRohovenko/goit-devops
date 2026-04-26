terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  count = var.enable_k8s_addons ? 1 : 0
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  count = var.enable_k8s_addons ? 1 : 0
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = var.enable_k8s_addons ? data.aws_eks_cluster.this[0].endpoint : "https://example.invalid"
  cluster_ca_certificate = var.enable_k8s_addons ? base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data) : ""
  token                  = var.enable_k8s_addons ? data.aws_eks_cluster_auth.this[0].token : ""
}

provider "helm" {
  kubernetes = {
    host                   = var.enable_k8s_addons ? data.aws_eks_cluster.this[0].endpoint : "https://example.invalid"
    cluster_ca_certificate = var.enable_k8s_addons ? base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data) : ""
    token                  = var.enable_k8s_addons ? data.aws_eks_cluster_auth.this[0].token : ""
  }
}

# S3 + DynamoDB for Terraform state (remote backend)
module "s3_backend" {
  source        = "./modules/s3-backend"
  bucket_name   = var.bucket_name
  table_name    = var.table_name
  force_destroy = var.backend_force_destroy
}

# VPC network (public + private subnets)
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
  cluster_name       = var.cluster_name
}

# ECR repo for Docker images
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = var.scan_on_push
}

# EKS cluster for the Django application
module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  vpc_cidr_block  = var.vpc_cidr_block
  node_group_name = var.node_group_name
  desired_size    = var.node_desired_size
  min_size        = var.node_min_size
  max_size        = var.node_max_size
  instance_types  = var.node_instance_types
}

module "rds" {
  source = "./modules/rds"

  name                          = var.db_name_prefix
  use_aurora                    = var.db_use_aurora
  engine                        = var.db_engine
  engine_version                = var.db_engine_version
  parameter_group_family_rds    = var.db_parameter_group_family_rds
  engine_cluster                = var.db_engine_cluster
  engine_version_cluster        = var.db_engine_version_cluster
  parameter_group_family_aurora = var.db_parameter_group_family_aurora
  aurora_instance_count         = var.db_aurora_instance_count
  instance_class                = var.db_instance_class
  allocated_storage             = var.db_allocated_storage
  db_name                       = var.db_database_name
  username                      = var.db_username
  password                      = var.db_password
  subnet_private_ids            = module.vpc.private_subnet_ids
  subnet_public_ids             = module.vpc.public_subnet_ids
  publicly_accessible           = var.db_publicly_accessible
  vpc_id                        = module.vpc.vpc_id
  vpc_cidr_block                = var.vpc_cidr_block
  multi_az                      = var.db_multi_az
  backup_retention_period       = var.db_backup_retention_period
  skip_final_snapshot           = var.db_skip_final_snapshot
  allowed_cidr_blocks           = var.db_allowed_cidr_blocks
  parameters                    = var.db_parameters

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

module "jenkins" {
  count  = var.enable_k8s_addons ? 1 : 0
  source = "./modules/jenkins"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  namespace           = var.jenkins_namespace
  chart_version       = var.jenkins_chart_version
  admin_user          = var.jenkins_admin_user
  admin_password      = var.jenkins_admin_password
  service_type        = var.jenkins_service_type
  persistence_enabled = var.jenkins_persistence_enabled
  app_repo_url        = var.app_repo_url
  gitops_repo_url     = var.gitops_repo_url
  gitops_repo_branch  = var.gitops_repo_branch

  depends_on = [module.eks]
}

module "argo_cd" {
  count  = var.enable_k8s_addons ? 1 : 0
  source = "./modules/argo_cd"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  namespace             = var.argo_cd_namespace
  chart_version         = var.argo_cd_chart_version
  service_type          = var.argo_cd_service_type
  gitops_repo_url       = var.gitops_repo_url
  gitops_repo_branch    = var.gitops_repo_branch
  gitops_chart_path     = var.gitops_chart_path
  application_name      = var.argo_cd_application_name
  destination_namespace = var.argo_cd_destination_namespace
  repo_is_private       = var.gitops_repo_is_private
  repo_username         = var.gitops_repo_username
  repo_password         = var.gitops_repo_password

  depends_on = [module.eks]
}
