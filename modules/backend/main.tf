# store the terraform state file in s3
# terraform {
#   backend "s3" {
#     bucket         = var.s3_bucket_name
#     key            = var.document_directory
#     region         = var.region
#     profile        = var.aws_profile_name
#     dynamodb_table = var.dynamodb_table_name
#     encrypt        = var.enable_data_encryption
#   }
# }

resource "aws_s3_bucket" "this" {
  bucket        = var.s3_bucket_name 
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_data_version #"Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
