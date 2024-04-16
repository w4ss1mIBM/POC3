provider "aws" {
  region = "eu-west-1"
}
# Fetch the latest Windows AMI provided by AWS or a specified owner
data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.windows_server_ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_owner] # Specify AWS for AWS-provided AMIs or the account ID for self or third-party AMIs
}

# Provision EC2 instances with the fetched AMI
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.windows.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnet.private_vpc_private_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = {
    Name = "${var.instance_name_prefix}"
  }

  credit_specification {
    cpu_credits = var.cpu_credits # Allow configuration of CPU credits via variable
  }
}
