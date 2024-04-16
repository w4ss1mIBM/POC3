# --------------------------
# AWS Backend Configuration
# --------------------------
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}


variable "environment" {
  type        = string
  description = "The deployment environment (e.g., prod, dev, staging)."
  default     = "int"
}

# --------------------------
# VPC Variables
# --------------------------


# Define input variables for VPCs and Subnets

variable "private_vpc" {
  description = "The name tag of the private VPC."
  type        = string
  default     = "private-vpc"
}

variable "public_vpc" {
  description = "The name tag of the public VPC."
  type        = string
  default     = "public-vpc"
}

variable "private_vpc_private_subnet" {
  description = "The name tag of the first private subnet in the private VPC."
  type        = string
  default     = "private-subnet-0"
}

variable "private_vpc_private_subnet_1" {
  description = "The name tag of the second private subnet in the private VPC."
  type        = string
  default     = "private-subnet-1"
}

variable "public_vpc_private_subnet_1" {
  description = "The name tag of the first private subnet in the public VPC."
  type        = string
  default     = "public-0"
}

variable "public_vpc_private_subnet_2" {
  description = "The name tag of the second private subnet in the public VPC."
  type        = string
  default     = "public-1"
}


# --------------------------
# NLB variables
# --------------------------


variable "nlb_name" {
  description = "The name of the NLB."
  type        = string
  default     = "nlb-PRIVATE-VPC"
}

variable "nlb_port_listener" {
  description = "The port on which the NLB listener operates."
  type        = number
  default     = 80
}

variable "nlb_tg_port" {
  description = "The port used by the NLB target group for routing traffic to the targets."
  type        = number
  default     = 80
}

# --------------------------
# EC2 instance VARIABLES
# --------------------------



variable "windows_server_ami_name_pattern" {
  description = "Name pattern to identify the Windows AMI."
  type        = string
  default     = "FRESH-AMI-*"
}

variable "ami_owner" {
  description = "Owner ID of the AMI"
  type        = string
  default     = "508072157138"
}


variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair for EC2 instances."
  type        = string
  default     = "key-playground"
}


variable "instance_name_prefix" {
  description = "Prefix for instance names to help with identifying resources."
  type        = string
  default     = "EC2-WEBAPP"
}

variable "cpu_credits" {
  description = "CPU credit option for burstable performance instances."
  type        = string
  default     = "unlimited"
}

variable "root_volume_size" {
  description = "Root volume size in GiB."
  type        = number
  default     = 40
}

variable "ebs_size" {
  description = "The size of the EBS volume in GiB."
  type        = number
  default     = 40
}

variable "ebs_device_name" {
  description = "The device name to attach the EBS volume to."
  type        = string
  default     = "/dev/sdh"
}


# --------------------------
# Security Group VARIABLES
# --------------------------

variable "sg_name" {
  description = "The name of the security group."
  type        = string
  default     = "app-sg"
}
variable "sg_ingress_ports" {
  description = "List of ingress ports and CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24"]
    }
  ]

}

variable "sg_egress_ports" {
  description = "List of egress ports and CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24"]
    }
  ]

}

variable "sg_alb_public_ingress_ports" {
  description = "List of ingress ports and CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24"]
    }
  ]

}
variable "sg_alb_private_ingress_ports" {
  description = "List of ingress ports and CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24"]
    }
  ]

}
# --------------------------
# ALB Configuration
# --------------------------

variable "ssl_policy" {
  description = "The SSL policy to use for HTTPS listeners"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}
variable "client_id_public" {
  description = "OIDC client ID for public alb"
  type        = string
}

variable "client_secret_public" {
  description = "OIDC client secret for public alb"
  type        = string
}
variable "client_id_private" {
  description = "OIDC client ID for private alb"
  type        = string
}

variable "client_secret_private" {
  description = "OIDC client secret for private alb"
  type        = string
}

variable "oidc_settings_private" {
  description = "OIDC authentication settings"
  type = object({
    authorization_endpoint     = string
    issuer                     = string
    token_endpoint             = string
    user_info_endpoint         = string
    scope                      = string
    on_unauthenticated_request = string
  })
  default = {
    authorization_endpoint     = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/authorize"
    issuer                     = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x"
    token_endpoint             = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/access_token"
    user_info_endpoint         = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/userinfo"
    scope                      = "openid profile bmwids b2xroles"
    on_unauthenticated_request = "authenticate"
  }
}

variable "oidc_settings_public" {
  description = "OIDC authentication settings"
  type = object({
    authorization_endpoint     = string
    issuer                     = string
    token_endpoint             = string
    user_info_endpoint         = string
    scope                      = string
    on_unauthenticated_request = string
  })
  default = {
    authorization_endpoint     = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/authorize"
    issuer                     = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x"
    token_endpoint             = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/access_token"
    user_info_endpoint         = "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/userinfo"
    scope                      = "openid profile bmwids b2xroles"
    on_unauthenticated_request = "authenticate"
  }
}
variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = "arn:aws:acm:eu-west-1:508072157138:certificate/b5ed352a-865f-49cd-bdf4-ed5abccc1b48"
}

# --------------------------
# ROUTE53 Configuration
# --------------------------
variable "private_subdomain_url" {
  description = "app.webserviceadministration-int.eu-west-1.aws.cloud.bmw"
  type        = string
  default     = "private2"
}

variable "private_hosted_zone_id" {
  description = "The id of Hosted Zone"
  type        = string
  default     = "Z05358721UPIUVROSJBSM"
}

variable "public_subdomain_url" {
  description = "app.webserviceadministration-int.eu-west-1.aws.cloud.bmw"
  type        = string
  default     = "publicc"
}

variable "public_hosted_zone_id" {
  description = "The id of Hosted Zone"
  type        = string
  default     = "Z05358721UPIUVROSJBSM"
}