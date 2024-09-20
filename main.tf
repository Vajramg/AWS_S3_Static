resource "aws_s3_bucket" "mybucket" {
  bucket = "var.aws_s3_bucket"

  tags = {
    Name        = "mybucket"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_ownership_controls" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "mybucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mybucket,
    aws_s3_bucket_public_access_block.mybucket,              
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index1" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index1.html"
  source = "index1.html"
  acl  =   "public-read"
  content_type="text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  content_type="text/html"
}
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "download.jpg"
  source = "download.jpg"
   acl  =   "public-read"
}
resource "aws_s3_object" "espresso" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "espresso.jpg"
  source = "espresso.jpg"
   acl  =   "public-read"
}
resource "aws_s3_object" "latte" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "latte.jpg"
  source = "latte.jpg"
   acl  =   "public-read"
}
resource "aws_s3_object" "cappuccino" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "cappuccino.jpg"
  source = "cappuccino.jpg"
   acl  =   "public-read"
}

resource "aws_s3_bucket_website_configuration" "ststic" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}