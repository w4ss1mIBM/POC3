# Fetch details of the private VPC by its name tag
data "aws_vpc" "private_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.private_vpc]
  }
}

# Fetch details of the public VPC by its name tag
data "aws_vpc" "public_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.public_vpc]
  }
}

# Fetch details of the first private subnet in the private VPC
data "aws_subnet" "private_vpc_private_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.private_vpc_private_subnet]
  }
}

# Fetch details of the second private subnet in the private VPC
data "aws_subnet" "private_vpc_private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = [var.private_vpc_private_subnet_1]
  }
}

# Fetch details of the first private subnet in the public VPC
data "aws_subnet" "public_vpc_private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = [var.public_vpc_private_subnet_1]
  }
}

# Fetch details of the second private subnet in the public VPC
data "aws_subnet" "public_vpc_private_subnet_2" {
  filter {
    name   = "tag:Name"
    values = [var.public_vpc_private_subnet_2]
  }
}

