
# Terraform Backend AWS Module

This Terraform module provisions an S3 bucket for securely storing Terraform state files and a DynamoDB table for state locking, designed to enhance the security and efficiency of managing Terraform's state in AWS.

## Features

- **S3 Bucket**: Secure storage for Terraform state files.
- **S3 Bucket Versioning**: Maintains a history of state files for rollback and auditing.
- **S3 Bucket Encryption**: Encrypts state files at rest using AES256 encryption.
- **DynamoDB Table**: Enables state locking to prevent concurrent state modifications.
- **PAY_PER_REQUEST Billing**: DynamoDB table billing based on usage for cost optimization.

## Usage

Include this module in your Terraform configuration with the necessary variables:

```hcl
module "terraform_backend" {
  source = "git::https://github.com/<your-namespace>/terraform-backend-aws-module.git"

  bucket_name         = "my-terraform-state-bucket"
  dynamodb_table_name = "my-terraform-lock-table"
  environment         = "prod"
  force_destroy       = false
}
```

## Variables

- `bucket_name`: Name of the S3 bucket for Terraform state files.
- `dynamodb_table_name`: Name of the DynamoDB table for state locking.
- `environment`: Target environment (e.g., prod, test).
- `force_destroy`: Enables forceful destruction of the S3 bucket, use with caution.

## Improvements and Best Practices

- **Caution with Force Destroy**: Designed for development, use cautiously in production.
- **Efficient Resource Tagging**: Resources are tagged for better management.
- **Enhanced Security with Encryption**: Default encryption for S3 buckets.
- **Versioning for Safety**: Enabled S3 bucket versioning for file recovery.
- **Cost-Effective DynamoDB Usage**: Utilizes PAY_PER_REQUEST billing for DynamoDB.

## Contributing

Contributions are welcome! Please follow the standard GitHub flow for submitting pull requests.
