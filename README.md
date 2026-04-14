# Lesson 7 — Terraform, EKS, ECR, Helm

This project provisions AWS infrastructure for a Django application and prepares a Helm chart for deployment into EKS.

## What Terraform creates

- S3 bucket for remote Terraform state
- DynamoDB table for Terraform state locking
- VPC with 3 public and 3 private subnets
- ECR repository for the Django Docker image
- EKS cluster with a managed node group

## Project structure

```text
lesson-7/
├── main.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   └── eks/
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           └── hpa.yaml
└── README.md
```

## Prerequisites

Install and configure these tools locally:

```bash
terraform version
aws --version
kubectl version --client
helm version
docker --version
```

You also need valid AWS credentials with permissions for S3, DynamoDB, VPC, ECR, EKS, EC2, and IAM.

## Step 1 — Bootstrap the remote backend

If the S3 bucket for remote state does not exist yet, create it once using local state.

Temporarily comment out the full backend block in `backend.tf` with `/* ... */`, then run:

```bash
rm -rf .terraform
terraform init
terraform apply -target=module.s3_backend
```

After the S3 bucket and DynamoDB table exist, uncomment `backend.tf` and migrate the local state into S3:

```bash
terraform init -migrate-state
```

## Step 2 — Create the infrastructure

Review the values in `terraform.tfvars`, then run:

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Useful outputs after apply:

```bash
terraform output
```

Expected important outputs:

- ECR repository URL
- EKS cluster name
- EKS endpoint
- VPC and subnet IDs

## Step 3 — Configure kubectl for EKS

Update kubeconfig to point to the new cluster:

```bash
aws eks update-kubeconfig --region eu-central-1 --name lesson-7-eks
kubectl get nodes
```

If nodes are listed, the cluster is ready.

## Step 4 — Build and push the Django image to ECR

This repository currently contains only infrastructure code. Run the following commands from the Django application repository that contains the `Dockerfile`.

Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 165690630824.dkr.ecr.eu-central-1.amazonaws.com
```

Build, tag, and push the image:

```bash
docker build -t django-app .
docker tag django-app:latest 165690630824.dkr.ecr.eu-central-1.amazonaws.com/lesson-7-ecr:latest
docker push 165690630824.dkr.ecr.eu-central-1.amazonaws.com/lesson-7-ecr:latest
```

If your Django app uses a different repository name or tag, update `charts/django-app/values.yaml`.

## Step 5 — Review the Helm chart

The chart in `charts/django-app` includes:

- Deployment using the ECR image
- Service of type `LoadBalancer`
- ConfigMap injected through `envFrom`
- HPA scaling from 2 to 6 replicas at 70% CPU

Default chart values are in `charts/django-app/values.yaml`.

Important note: only non-secret environment variables should stay in `ConfigMap`. If you have passwords or tokens from the Django project, move them into a Kubernetes `Secret`.

## Step 6 — Deploy with Helm

Install the chart:

```bash
helm install django-app ./charts/django-app
```

Upgrade after edits:

```bash
helm upgrade --install django-app ./charts/django-app
```

Check the deployment:

```bash
kubectl get pods
kubectl get svc
kubectl get hpa
```

## Step 7 — Verify external access

Once the `LoadBalancer` service receives an external address, open it in a browser or test with curl.

```bash
kubectl get svc django-app
```

## Cleanup

To remove the application from Kubernetes:

```bash
helm uninstall django-app
```

To remove AWS infrastructure:

```bash
terraform destroy
```

If you also want to remove the remote backend, first migrate state back to local state, then destroy `module.s3_backend` separately.
