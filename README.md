# Final DevOps Project

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
- Prometheus in Kubernetes
- Grafana in Kubernetes

## Repositories

There are 3 repositories in this final project:

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

Set sensitive values explicitly in `terraform.tfvars` before the first apply.
At minimum, define `db_password`, `jenkins_admin_password`, and `grafana_admin_password` there.

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

With the current configuration, the second Terraform apply installs:

- Jenkins
- Argo CD
- Prometheus
- Grafana

Monitoring is installed by Terraform from `modules/monitoring` through Helm releases.
It is not installed manually.

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
db_backup_retention_period     = 7
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
db_backup_retention_period        = 7
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

## Step 5.1 — Open Grafana

Get Grafana admin password:

```bash
terraform output -raw grafana_admin_password
```

Open Grafana locally:

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Open `http://localhost:3000` and log in with:

- username: `admin`
- password: output from the command above

Prometheus is already configured as the default Grafana data source by Terraform.

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

For this project, ECR push permission is enough.

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

## Step 8.1 — Create The App Secret

The current GitOps chart expects the Django application secret to exist in the cluster.
This secret is created manually and is not managed by Terraform in this repository.

Create it before testing the application deployment:

```bash
kubectl create secret generic django-app-secret \
	-n default \
	--from-literal=SECRET_KEY='django-secret-key-final-project' \
	--from-literal=DB_USER='postgres' \
	--from-literal=DB_PASSWORD='ChangeMe123!' \
	--dry-run=client -o yaml | kubectl apply -f -
```

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

## Step 10 — Check Monitoring

Check monitoring resources:

```bash
kubectl get all -n monitoring
```

Open Prometheus:

```bash
kubectl port-forward svc/prometheus-server 9090:80 -n monitoring
```

Open Grafana:

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

In Grafana, verify the Prometheus data source and run a simple query such as:

```promql
up
```

For app usage visualization, example queries are:

```promql
sum by (pod) (
	rate(container_cpu_usage_seconds_total{namespace="default", pod=~"django-app-.*", container!="POD", container!=""}[5m])
)
```

```promql
sum by (pod) (
	container_memory_usage_bytes{namespace="default", pod=~"django-app-.*", container!="POD", container!=""}
)
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

Before destroying infrastructure, remove the GitOps-deployed Django application first.
This project deploys the app through Argo CD, so the `default` namespace may still contain a `LoadBalancer` service even after Jenkins, Argo CD, or monitoring are removed.
If that service stays alive, AWS keeps the external load balancer and Terraform cannot delete the VPC, subnets, or internet gateway.

### Step 1 — Remove The Django Application

Delete the Argo CD application:

```bash
kubectl delete application django-app -n argocd
```

Verify that app resources are gone:

```bash
kubectl get all -n default
kubectl get svc -n default
```

If anything is still left in the `default` namespace, delete it manually:

```bash
kubectl delete svc django-app -n default --ignore-not-found
kubectl delete deployment django-app -n default --ignore-not-found
kubectl delete hpa django-app -n default --ignore-not-found
kubectl delete configmap django-app-config -n default --ignore-not-found
kubectl delete secret django-app-secret -n default --ignore-not-found
```

### Step 2 — Destroy Infrastructure But Keep The Terraform Backend

To keep the S3 state bucket and DynamoDB lock table, do not run plain `terraform destroy`.
Destroy only these modules:

```bash
terraform destroy \
	-target=module.monitoring \
	-target=module.argo_cd \
	-target=module.jenkins \
	-target=module.rds \
	-target=module.eks \
	-target=module.ecr \
	-target=module.vpc
```

### Step 3 — Verify Only Backend Resources Remain

After destroy completes, check Terraform state:

```bash
terraform state list
```

Expected result:

- only backend resources remain
- mostly resources under `module.s3_backend`
