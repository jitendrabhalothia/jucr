terraform {
  backend "s3" {
    bucket  = "my-jucr-tfstate"
    key     = "eks/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}