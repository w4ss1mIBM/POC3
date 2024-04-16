variable "bucket_name" {
  description = "Remote S3 Bucket Name"
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
    error_message = "Bucket Name must not be empty and must follow S3 naming rules."
  }
  default     = "wsa-backend-terraform-tfstate-int"
}

variable "dynamodb_table_name" {
  type    = string
  default     = "wsa-terraform-state-locking-int"
}
variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment this backend is created for (e.g., prod, test)."
  type        = string
  default = "int"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}
