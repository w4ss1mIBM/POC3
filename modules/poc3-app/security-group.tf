#EC2 Instance Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name_prefix}-${var.sg_name}"
  description = "EC2 inbound and outbound traffic"
  vpc_id      = data.aws_vpc.private_vpc.id


  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_ports
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${var.instance_name_prefix}-${var.sg_name}"
  }
}


#VPC Endpoint Security Group in Public VPC

resource "aws_security_group" "endpoint_security_group" {
  name_prefix = "vpc-endpoint-sg-"
  vpc_id      = data.aws_vpc.public_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.public_vpc.cidr_block]
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

#ALB Security Groups in Public and Private VPCs

resource "aws_security_group" "alb_public" {
  name_prefix = "alb-sg-public-"
  vpc_id      = data.aws_vpc.public_vpc.id

  dynamic "ingress" {
    for_each = var.sg_alb_public_ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  depends_on = [aws_vpc_endpoint.vpc_endpoint]

  tags = {
    Name = "alb-sg-public-subnet-public-vpc"
  }
}


resource "aws_security_group" "alb_private" {
  name_prefix = "alb-sg-private-"
  vpc_id      = data.aws_vpc.private_vpc.id

  dynamic "ingress" {
    for_each = var.sg_alb_private_ingress_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Name = "alb-sg-private-subnet-private-vpc"
  }
}
