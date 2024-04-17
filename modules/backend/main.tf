module "terraform_backend" {
  source = "./backend/"

  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  environment         = var.environment
  force_destroy       = var.force_destroy
}