provider "aws" {
  region = "ap-south-1"
}

# S3 bucket for Terraform state
resource "aws_s3_bucket" "tf_state_file_smd" {
  bucket = "my-terraform-state-smd29-py"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Shared"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state_file_smd.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state_file_smd.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "Shared"
  }
}
