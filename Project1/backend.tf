terraform {
  backend "s3" {
    bucket = "aijan-kaizen"                         
    key    = "project1/terraform.tfstate"
    region = "us-east-1"
  }
}