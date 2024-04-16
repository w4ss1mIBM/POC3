# Terraform Module Prerequisites

Before using this Terraform module, ensure you have completed the following prerequisites:

## 1. Create User For Terraform


### 1.1. User for Terraform

- Create an IAM user with programmatic access.
- Attach policies to the user for managing AWS resources through Terraform.

## 2. Create VPC with Two Subnets

### 2.1. VPC

- Define the VPC configuration including CIDR block, route table, and internet gateway.

### 2.2. Subnets

- Create two subnets within the VPC in different availability zones.

## 3. Configure Backend for Terraform State

### 3.1. Setup S3 Bucket and DynamoDB Variables

- In Folder called backend in variables.tf change the name of Dynamo TABLE and Bucket S3 that we want to create for the backend of Terraform

## 4. Store Secrets in GitHub Secrets

### 4.1. GitHub Secrets

Store the following secrets in GitHub Secrets for secure access:
- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `AWS_REGION`: The AWS region where resources will be deployed.
- `TF_BACKEND_BUCKET`: Name of the S3 bucket for storing Terraform state.
- `TF_BACKEND_KEY`: Key name for the Terraform state file in the S3 bucket.
- `TF_BACKEND_DYNAMODB_TABLE`: Name of the DynamoDB table for Terraform state locking.
- `OIDC_CLIENT_ID`: Your OIDC client ID for accessing AWS services.
- `OIDC_CLIENT_SECRET`: Your OIDC client secret for accessing AWS services.

## 5. Modify Terraform Variables

### 5.1. VPC Variables

- Update VPC-related variables such as CIDR block, subnet configurations, etc., as per your requirements.

### 5.2. Security Group and ALB Variables

- Adjust security group and Application Load Balancer (ALB) configurations based on your needs.

## 6. Check All Variables

### 6.1. Variable Validation

- Verify all variables in the Terraform configuration to ensure they match your environment and requirements.

## 7. Execute Terraform Workflows

### 7.1. Provision Backend Terraform

- This workflow provisions the S3 bucket and DynamoDB table for Terraform state management.
- Ensure all configurations are defined in your Terraform files before execution.
- Execute the Terraform plan to review changes, then apply with the Terraform apply command.
- Verify the creation of resources through the AWS Management Console or Terraform apply logs.

### 7.2. Provision P/D AWS Resources

- This workflow provisions Production (P) and Development (D) AWS resources as defined in your Terraform files.
- Includes creation of EC2 instances, VPC configurations, subnets, and other required AWS resources.
- Start with the Terraform plan command to review planned resources creation, then apply with the Terraform apply command.
- Monitor the logs for any errors or warnings and verify all resources are provisioned as expected.

**Important:** Always review Terraform plans before applying to avoid unintended changes to your infrastructure. Enable logging for both workflows to capture execution process details, crucial for troubleshooting any provisioning issues.

# Terraform AWS Infrastructure Deployment POC1 Module

This project uses Terraform to provision and manage AWS resources for POC1 applications Type. It encompasses configurations for network resources, compute instances, storage, monitoring, and security, ensuring a highly available and secure application deployment.

## Overview

Our Terraform setup orchestrates the creation and management of the following AWS resources:

### Networking

- **VPC Fetching (`vpc-fetch.tf`)**: Retrieves existing VPC and subnet information, ensuring resources are correctly placed within the network.

### Compute Resources

- **EC2 Instances (`ec2.tf`)**: Provisions web servers or applications on EC2 instances, optimized for performance and cost.

- **Application Load Balancers (ALB) (`alb-private.tf`)**: Distributes incoming traffic across EC2 instances to improve availability.

### Storage

- **EBS Volumes (`ebs-volume.tf`)**: Provides additional or specialized storage for EC2 instances.

### Security

- **Security Groups (`security-group.tf`)**: Controls access to EC2 instances and ALBs with firewall rules.

### Monitoring

- **CloudWatch Monitoring (`monitoring.tf`)**: Configure Roles And Sets up alarms and notifications for infrastructure monitoring with Amazon CloudWatch.

### Outputs

- **Outputs (`output.tf`)**: Displays important information such as IP addresses and DNS names of the resources.

### Configuration

- **Variables (`variables.tf`)**: Allows customization of the deployment through input variables.

- **Local Values (`locals.tf`)**: Simplifies configuration by defining common constants and calculated values.

## For Non-Technical Stakeholders

This project automates the setup of our web application infrastructure on AWS. It's designed to be secure, scalable, and monitored, ensuring optimal performance and availability. Terraform allows for easy adjustments and consistent environments across development, staging, and production.

### Key Benefits

- **Scalability**: Adjust resources to meet demand.
- **Security**: Ensure application protection through customizable firewall rules.
- **High Availability**: Maintain application performance and availability through load balancing and monitoring.
- **Cost-Effectiveness**: Scale resources according to use, minimizing costs.

## Getting Started

To use this module for deploying your AWS infrastructure, follow these steps:

1. Ensure you have Terraform installed and configured.
2. Clone this repository to your local machine.
3. Navigate to the cloned repository and update the `variables.tf` file with your specific configuration values.
4. Initialize Terraform to download necessary providers and set up the backend:
   ```
   terraform init
   ```
5. Apply the Terraform configuration to create the resources in AWS:
   ```
   terraform apply
   ```
6. Confirm the action by typing `yes` when prompted.

## Contributing

Contributions to this project are welcome! To contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes with clear, descriptive messages.
4. Push your branch and submit a pull request.

Please note that this project adheres to a code of conduct. By participating, you are expected to uphold this code.

### Maintainer

- [@w4ss1m]- For any questions or suggestions.



<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.51.0 |

Basic usage of this module is as follows:
```hcl
module "deploy_app_poc1" {
  source = "./modules/poc1-app/"

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
  sg_ports_egress                 = var.sg_ports_egress
  sg_protocol                     = var.sg_protocol
  selected_vpc_name               = var.selected_vpc_name
  app_subnet                      = var.app_subnet
  alb_subnet                      = var.alb_subnet
  alb_ingress_cidr_blocks         = var.alb_ingress_cidr_blocks
  client_id                       = var.client_id
  client_secret                   = var.client_secret
  sg_egress_ports                 = var.sg_egress_ports
  sg_ingress_ports                = var.sg_ingress_ports

}

```
  ## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.ebs_volume_for_windows_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_cloudwatch_ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_agent_server_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_instance_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.windows_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lb.alb_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb_ec2_instance_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.ec2_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.ebs_att](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_ami.windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.alb_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.app_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
  ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | CIDR blocks for ALB security group ingress. | `list(string)` | <pre>[<br>  "127.0.0.1/32",<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_alb_subnet"></a> [alb\_subnet](#input\_alb\_subnet) | Subnet for the Application Load Balancer. | `string` | `"private-subnet-1"` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | Owner ID of the AMI | `string` | `"694493444487"` | no |
| <a name="input_app_subnet"></a> [app\_subnet](#input\_app\_subnet) | Subnet for application servers. | `string` | `"private-subnet-0"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The ARN of the ACM certificate | `string` | `"arn:aws:acm:eu-west-1:508072157138:certificate/b5ed352a-865f-49cd-bdf4-ed5abccc1b48"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | OIDC client ID | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | OIDC client secret | `string` | n/a | yes |
| <a name="input_cpu_credits"></a> [cpu\_credits](#input\_cpu\_credits) | CPU credit option for burstable performance instances. | `string` | `"unlimited"` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | The device name to attach the EBS volume to. | `string` | `"/dev/sdh"` | no |
| <a name="input_ebs_size"></a> [ebs\_size](#input\_ebs\_size) | The size of the EBS volume in GiB. | `number` | `40` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The deployment environment (e.g., prod, dev, staging). | `string` | `"int"` | no |
| <a name="input_instance_name_prefix"></a> [instance\_name\_prefix](#input\_instance\_name\_prefix) | Prefix for instance names to help with identifying resources. | `string` | `"EC2-WEBAPP"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type. | `string` | `"t2.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the AWS key pair for EC2 instances. | `string` | `"key-playground"` | no |
| <a name="input_oidc_settings"></a> [oidc\_settings](#input\_oidc\_settings) | OIDC authentication settings | <pre>object({<br>    authorization_endpoint     = string<br>    issuer                     = string<br>    token_endpoint             = string<br>    user_info_endpoint         = string<br>    scope                      = string<br>    on_unauthenticated_request = string<br>  })</pre> | <pre>{<br>  "authorization_endpoint": "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/authorize",<br>  "issuer": "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x",<br>  "on_unauthenticated_request": "authenticate",<br>  "scope": "openid profile bmwids b2xroles",<br>  "token_endpoint": "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/access_token",<br>  "user_info_endpoint": "https://auth-i.bmwgroup.net:443/auth/oauth2/realms/root/realms/intranetb2x/userinfo"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root volume size in GiB. | `number` | `40` | no |
| <a name="input_selected_vpc_name"></a> [selected\_vpc\_name](#input\_selected\_vpc\_name) | Name of the VPC for deployment. | `string` | `"private-vpc"` | no |
| <a name="input_sg_egress_ports"></a> [sg\_egress\_ports](#input\_sg\_egress\_ports) | List of egress ports and CIDR blocks | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "10.0.0.0/16"<br>    ],<br>    "from_port": 80,<br>    "protocol": "-1",<br>    "to_port": 65535<br>  },<br>  {<br>    "cidr_blocks": [<br>      "192.168.1.0/24"<br>    ],<br>    "from_port": 5432,<br>    "protocol": "tcp",<br>    "to_port": 5432<br>  }<br>]</pre> | no |
| <a name="input_sg_ingress_ports"></a> [sg\_ingress\_ports](#input\_sg\_ingress\_ports) | List of ingress ports and CIDR blocks | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "10.0.0.0/16"<br>    ],<br>    "from_port": 80,<br>    "protocol": "-1",<br>    "to_port": 80<br>  },<br>  {<br>    "cidr_blocks": [<br>      "192.168.1.0/24"<br>    ],<br>    "from_port": 443,<br>    "protocol": "tcp",<br>    "to_port": 443<br>  }<br>]</pre> | no |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | The name of the security group. | `string` | `"app-sg"` | no |
| <a name="input_sg_ports_egress"></a> [sg\_ports\_egress](#input\_sg\_ports\_egress) | List of egress ports for the security group. | `list(number)` | <pre>[<br>  80,<br>  443<br>]</pre> | no |
| <a name="input_sg_protocol"></a> [sg\_protocol](#input\_sg\_protocol) | Protocol for the security group rules. | `string` | `"tcp"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | The SSL policy to use for HTTPS listeners | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_windows_server_ami_name_pattern"></a> [windows\_server\_ami\_name\_pattern](#input\_windows\_server\_ami\_name\_pattern) | Name pattern to identify the Windows AMI. | `string` | `"FRESH-AMI-*"` | no |
  ## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the Application Load Balancer. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the Application Load Balancer. |
| <a name="output_alb_sg_id"></a> [alb\_sg\_id](#output\_alb\_sg\_id) | The ID of the ALB security group in the private subnet. |
| <a name="output_app_subnet_id"></a> [app\_subnet\_id](#output\_app\_subnet\_id) | The ID of the application subnet. |
| <a name="output_db_subnet_id"></a> [db\_subnet\_id](#output\_db\_subnet\_id) | The ID of the alb subnet. |
| <a name="output_selected_vpc_id"></a> [selected\_vpc\_id](#output\_selected\_vpc\_id) | The ID of the selected VPC. |
| <a name="output_tg_arn"></a> [tg\_arn](#output\_tg\_arn) | The ARN of the Target Group associated with the ALB. |
| <a name="output_tls_sg_id"></a> [tls\_sg\_id](#output\_tls\_sg\_id) | The ID of the security group allowing TLS traffic. |
| <a name="output_windows_ec2_instance_ids"></a> [windows\_ec2\_instance\_ids](#output\_windows\_ec2\_instance\_ids) | The IDs of the Windows EC2 instances. |
| <a name="output_windows_ec2_instance_private_ips"></a> [windows\_ec2\_instance\_private\_ips](#output\_windows\_ec2\_instance\_private\_ips) | The private IP addresses of the Windows EC2 instances. |
| <a name="output_windows_ec2_instance_public_ips"></a> [windows\_ec2\_instance\_public\_ips](#output\_windows\_ec2\_instance\_public\_ips) | The public IP addresses of the Windows EC2 instances. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
## Footer
Contributor Names
