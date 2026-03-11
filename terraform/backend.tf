terraform {
  backend "s3" {
    bucket         = "pratap-terraform-state-bucket"
    key            = "infra-pipeline2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}