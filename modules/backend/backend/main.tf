provider "aws" {
  region = var.region
}

# Create an S3 bucket to store the Terraform state files.
# The force_destroy attribute is set to true to allow the bucket to be destroyed even if it contains objects. 
# This should be used with caution in production environments.
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  # Adding tags can help with cost allocation and resource management.
  tags = {
    Name        = "TerraformStateBucket"
    Environment = var.environment
  }
}

# Enable versioning on the S3 bucket to keep a history of state files which can be useful for rollback and history tracking.
resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption on the S3 bucket for added security of state files.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a DynamoDB table for Terraform state locking to prevent simultaneous state file writes.
# PAY_PER_REQUEST billing mode is used to manage costs efficiently for varying workloads.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Tags for DynamoDB table
  tags = {
    Name        = "TerraformStateLocks"
    Environment = var.environment
  }
}
