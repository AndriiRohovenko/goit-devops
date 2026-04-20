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

See outputs:

```bash
terraform output
```

## Step 3 — Connect kubectl To EKS

```bash
aws eks update-kubeconfig --region eu-central-1 --name lesson-7-eks
kubectl get nodes
```

If nodes are shown, cluster is ready.

## Step 4 — Open Jenkins And Argo CD

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

## Step 5 — Add Credentials In Jenkins

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

## Step 6 — Create Jenkins Pipeline Job

In Jenkins create a Pipeline job:

1. New Item
2. Name: `django-app-pipeline`
3. Type: `Pipeline`
4. Choose `Pipeline script from SCM`
5. Git repo: `https://github.com/AndriiRohovenko/django-app.git`
6. Branch: `*/main`
7. Script path: `Jenkinsfile`

## Step 7 — Check GitOps Repo

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

## Step 8 — Run First Deployment

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
