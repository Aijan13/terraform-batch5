provider aws {
    region = var.region
}
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "own" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.own,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_accelerate_configuration" "config" {
  bucket = aws_s3_bucket.website_bucket.id
  status = "Enabled"
}


# resource "aws_s3_bucket_policy" "allow_access" {
#   bucket = aws_s3_bucket.website_bucket.id
#   policy = data.aws_iam_policy_document.allow_access.json
# }

# data "aws_iam_policy_document" "allow_access" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }
#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]
#     resources = [
#       aws_s3_bucket.website_bucket.arn,
#       "${aws_s3_bucket.website_bucket.arn}/*",
#     ]
#   }
# }



# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.www_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = [
#           "${aws_s3_bucket.www_bucket.arn}/*"
#         ]
#       }
#     ]
#   })
# }



resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  depends_on = [aws_s3_bucket.website_bucket]
  bucket = aws_s3_bucket.website_bucket        #not sure
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "error" {
  depends_on = [aws_s3_bucket.website_bucket]
  bucket = aws_s3_bucket.website_bucket     
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "website_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.subdomain_name
  type    = "NS"
  ttl     = "30"
} 
