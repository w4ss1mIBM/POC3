# Create a Network Load Balancer (NLB) within the private subnet of the private VPC
resource "aws_lb" "private_nlb" {
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = [data.aws_subnet.private_vpc_private_subnet.id]
}

# Add a TCP listener to the NLB
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.private_nlb.arn
  port              = var.nlb_port_listener
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

# Define the target group for NLB with health check configuration
resource "aws_lb_target_group" "nlb_target_group" {
  name_prefix = "nlb-"
  port        = var.nlb_tg_port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.private_vpc.id

  health_check {
    port     = "traffic-port"
    protocol = "TCP"
  }
}

# Register EC2 instances as targets in the NLB target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = aws_instance.ec2_instance.id
  port             = var.nlb_tg_port
}
