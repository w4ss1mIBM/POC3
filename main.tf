terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# terraform {
#   backend "s3" {
#     bucket         = "app-playground-terraform-tfstate-stage-poc3"
#     key            = "state/int/ec2-tfstate/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "terraform-state-locking-playground-s3-tfstate-stage-poc3"
#     encrypt        = true
#   }
# }

module "deploy_app_poc3" {
  source = "./modules/poc3-app"

  region                          = var.region
  windows_server_ami_name_pattern = var.windows_server_ami_name_pattern
  ami_owner                       = var.ami_owner
  instance_type                   = var.instance_type
  key_name                        = var.key_name
  instance_name_prefix            = var.instance_name_prefix
  cpu_credits                     = var.cpu_credits
  root_volume_size                = var.root_volume_size
  ebs_size                        = var.ebs_size
  ebs_device_name                 = var.ebs_device_name
  sg_name                         = var.sg_name
  sg_egress_ports                 = var.sg_egress_ports
  sg_ingress_ports                = var.sg_ingress_ports

  // VPC and subnet-related variables
  private_vpc                  = var.private_vpc
  public_vpc                   = var.public_vpc
  private_vpc_private_subnet   = var.private_vpc_private_subnet
  private_vpc_private_subnet_1 = var.private_vpc_private_subnet_1
  public_vpc_private_subnet_1  = var.public_vpc_private_subnet_1
  public_vpc_private_subnet_2  = var.public_vpc_private_subnet_2
  // NLB-related variables
  nlb_name              = var.nlb_name
  nlb_port_listener     = var.nlb_port_listener
  nlb_tg_port           = var.nlb_tg_port
  client_id_private     = var.client_id_private
  client_id_public      = var.client_id_public
  client_secret_private = var.client_secret_private
  client_secret_public  = var.client_secret_public
  oidc_settings_private = var.oidc_settings_private
  oidc_settings_public  = var.oidc_settings_public

  certificate_arn        = var.certificate_arn
  private_hosted_zone_id = var.private_hosted_zone_id
  public_hosted_zone_id  = var.public_hosted_zone_id
  public_subdomain_url   = var.public_subdomain_url
  private_subdomain_url  = var.private_subdomain_url

}
