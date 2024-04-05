# resource "aws_key_pair" "deployer" {
#   key_name   = "my-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

# resource "aws_s3_bucket" "example" {
#   bucket_prefix = "hello-"
#   force_destroy = true 
# }

# resource "aws_s3_object" "object" {
#   depends_on = [aws_s3_bucket.example]
#   bucket = "aijan13"
#   key    = "main2.tf"
#   source = "main2.tf"

# }