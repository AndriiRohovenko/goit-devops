/*
terraform {
  backend "s3" {
    bucket         = "andrii-goit-terraform-state-lesson-5"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
*/