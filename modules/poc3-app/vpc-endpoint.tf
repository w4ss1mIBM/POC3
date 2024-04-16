# Create a VPC Endpoint Service for the NLB, to be consumed by ALB in another VPC
resource "aws_vpc_endpoint_service" "nlb_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.private_nlb.arn]
  tags = {
    Name = "vpc_endpoint_nlb_service"
  }
}


# Create an Interface VPC endpoint for the NLB's Endpoint Service in the public VPC
resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id             = data.aws_vpc.public_vpc.id
  service_name       = aws_vpc_endpoint_service.nlb_service.service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  subnet_ids         = [data.aws_subnet.public_vpc_private_subnet_1.id]

  policy = <<POLICY
  {
    "Statement": [{
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }]
  }
  POLICY

  tags = {
    Name = "vpc_endpoint"
  }
}
