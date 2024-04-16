terraform {
  backend "s3" {
    bucket = "aijan-kaizen"
    key    = "ohio/terraform.tfstate"
    region = "us-east-2"
  }
}
