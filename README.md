# Lesson 8-9

This repository is for infrastructure only.

It creates AWS resources and installs Jenkins and Argo CD into EKS.

## What This Project Does

This project creates:

- S3 bucket for Terraform state
- DynamoDB table for Terraform lock
- VPC and subnets
- ECR repository
- EKS cluster
- RDS or Aurora database
- Jenkins in Kubernetes
- Argo CD in Kubernetes

## Repositories

There are 3 repositories in this homework:

- `goit-devops` -> Terraform infrastructure
- `django-app` -> Django code, Dockerfile, Jenkinsfile
- `django-gitops` -> Helm chart for deployment

Important:

- this repo does not store the Django Helm chart
- the chart is stored in `django-gitops`
- Argo CD watches `charts/django-app` in `django-gitops`

## How The Flow Works

1. Terraform creates infrastructure.
2. Jenkins builds Docker image from `django-app`.
3. Jenkins pushes image to ECR.
4. Jenkins updates image tag in `django-gitops`.
5. Argo CD sees the change and deploys the app.

## Before You Start

You need these tools:

```bash
terraform version
aws --version
kubectl version --client
helm version
docker --version
```

You also need AWS credentials with access to EKS, ECR, VPC, S3, DynamoDB, EC2, and IAM.

## My Main Settings

This project currently uses:

- region: `eu-central-1`
- EKS cluster name: `lesson-7-eks`
- ECR repository: `lesson-7-ecr`
- node count: `5`
- node type: `t3.small`
- Jenkins namespace: `jenkins`
- Argo CD namespace: `argocd`

## Step 1 — Create Backend For Terraform State

If S3 backend does not exist yet, create it first.

Temporarily disable the backend block in `backend.tf`, then run:

```bash
rm -rf .terraform
terraform init
terraform apply -target=module.s3_backend
```

Then enable the backend again and run:

```bash
terraform init -migrate-state
```

## Step 2 — Create Infrastructure

Run these commands:

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

For a fresh environment, keep `enable_k8s_addons = false` in `terraform.tfvars`.
This creates AWS infrastructure first, including VPC, EKS, ECR, and RDS.

See outputs:

```bash
terraform output
```

## Step 3 — Install Jenkins And Argo CD

After EKS exists, enable the in-cluster add-ons:

```hcl
enable_k8s_addons = true
```

Then run:

```bash
terraform plan
terraform apply
```

## Database Module

This repo now includes a reusable module in `modules/rds`.

It can create either:

- a standard Amazon RDS instance for PostgreSQL or MySQL
- or an Aurora cluster with one writer and optional readers

Switching is controlled by `db_use_aurora` in `terraform.tfvars`.

Example standard RDS settings:

```hcl
db_use_aurora                  = false
db_engine                      = "postgres"
db_engine_version              = "17.2"
db_parameter_group_family_rds  = "postgres17"
db_instance_class              = "db.t3.medium"
db_allocated_storage           = 20
db_database_name               = "app"
db_username                    = "postgres"
db_password                    = "ChangeMe123!"
```

Example Aurora settings:

```hcl
db_use_aurora                     = true
db_engine_cluster                 = "aurora-postgresql"
db_engine_version_cluster         = "15.3"
db_parameter_group_family_aurora  = "aurora-postgresql15"
db_aurora_instance_count          = 2
db_instance_class                 = "db.t3.medium"
db_database_name                  = "app"
db_username                       = "postgres"
db_password                       = "ChangeMe123!"
```

Useful outputs:

- `terraform output db_endpoint`
- `terraform output db_reader_endpoint`
- `terraform output db_security_group_id`

Example parameter group values:

```hcl
db_parameters = {
	max_connections = "200"
	log_statement   = "ddl"
	work_mem        = "4096"
}
```

## Step 4 — Connect kubectl To EKS

```bash
aws eks update-kubeconfig --region eu-central-1 --name lesson-7-eks
kubectl get nodes
```

If nodes are shown, cluster is ready.

## Step 5 — Open Jenkins And Argo CD

Get Jenkins URL:

```bash
terraform output jenkins_url
```

Get Argo CD URL:

```bash
terraform output argocd_server_url
```

Get Argo CD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

Login to Argo CD with:

- username: `admin`
- password: secret from command above

## Step 6 — Add Credentials In Jenkins

Create these credentials in Jenkins.

### GitHub token

- Type: `Secret text`
- ID: `github-token`

This token should allow push access to `django-gitops`.

### AWS credentials

Create an IAM user for Jenkins and store these in Jenkins:

- `aws-access-key-id`
- `aws-secret-access-key`

Both should be `Secret text`.

For homework, ECR push permission is enough.

## Step 7 — Create Jenkins Pipeline Job

In Jenkins create a Pipeline job:

1. New Item
2. Name: `django-app-pipeline`
3. Type: `Pipeline`
4. Choose `Pipeline script from SCM`
5. Git repo: `https://github.com/AndriiRohovenko/django-app.git`
6. Branch: `*/main`
7. Script path: `Jenkinsfile`

## Step 8 — Check GitOps Repo

The `django-gitops` repository must contain:

```text
charts/
└── django-app/
	├── Chart.yaml
	├── values.yaml
	└── templates/
```

Argo CD uses:

- repo: `django-gitops`
- branch: `main`
- path: `charts/django-app`

## Step 9 — Run First Deployment

Push a new commit to `django-app`.

Then this should happen:

1. Jenkins builds image
2. Jenkins pushes image to ECR
3. Jenkins updates `django-gitops`
4. Argo CD deploys the app

Useful commands:

```bash
aws ecr describe-images --repository-name lesson-7-ecr --region eu-central-1 --output json
kubectl get applications -n argocd
kubectl get pods -n default
kubectl get svc -A
```

## Useful Check Commands

```bash
terraform output
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get applications -n argocd
helm list -A
```

## Cleanup

To remove everything:

```bash
terraform destroy
```
