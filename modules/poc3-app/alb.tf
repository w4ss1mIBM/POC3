########################## ALB PRIVATE VPC ####################################

# Create an Application Load Balancer (ALB) within the private subnets of the private VPC
resource "aws_lb" "alb_private" {
  name               = "alb-private-${var.environment}"
  internal           = true
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.private_vpc_private_subnet.id,
    data.aws_subnet.private_vpc_private_subnet_1.id
  ]
  security_groups = [aws_security_group.alb_private.id]
}

# Create a target group for the ALB, targeting EC2 instances within the private VPC
resource "aws_lb_target_group" "alb_target_group_private" {
  name     = "alb-tg-private-${var.environment}"
  vpc_id   = data.aws_vpc.private_vpc.id
  port     = 80
  protocol = "HTTP"
  health_check {
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }
}

# Attach EC2 instances to the target group
resource "aws_lb_target_group_attachment" "ec2_tg_attachment" {
  # Improved readability by using descriptive resource and variable names.
  target_group_arn = aws_lb_target_group.alb_target_group_private.arn
  target_id        = aws_instance.ec2_instance.id
  port             = 80
}

resource "aws_lb_listener" "alb_listener_private" {
  load_balancer_arn = aws_lb.alb_private.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint     = var.oidc_settings_private.authorization_endpoint
      client_id                  = var.client_secret_private
      client_secret              = var.client_secret_private
      issuer                     = var.oidc_settings_private.issuer
      token_endpoint             = var.oidc_settings_private.token_endpoint
      user_info_endpoint         = var.oidc_settings_private.user_info_endpoint
      scope                      = var.oidc_settings_private.scope
      on_unauthenticated_request = var.oidc_settings_private.on_unauthenticated_request
    }

  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_private.arn
  }
}

resource "aws_lb_listener" "alb_listener_private_HTTP" {
  load_balancer_arn = aws_lb.alb_private.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_private.arn
  }
}
########################## ALB PUBLIC VPC ####################################
# Create an Application Load Balancer (ALB) within the public subnets of the public VPC
resource "aws_lb" "alb_public" {
  name               = "alb-public-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.public_vpc_private_subnet_1.id,
    data.aws_subnet.public_vpc_private_subnet_2.id
  ]
  security_groups = [aws_security_group.alb_public.id]
}

# Create a target group for the public ALB, targeting resources via IP
resource "aws_lb_target_group" "alb_target_group_public" {
  name        = "alb-tg-public-${var.environment}"
  vpc_id      = data.aws_vpc.public_vpc.id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  health_check {
    interval            = 30
    protocol            = "HTTPS"
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }
}

# Create a listener for the public ALB, forwarding traffic to the target group
resource "aws_lb_listener" "alb_listener_public" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  default_action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint     = var.oidc_settings_public.authorization_endpoint
      client_id                  = var.client_id_public
      client_secret              = var.client_secret_public
      issuer                     = var.oidc_settings_public.issuer
      token_endpoint             = var.oidc_settings_public.token_endpoint
      user_info_endpoint         = var.oidc_settings_public.user_info_endpoint
      scope                      = var.oidc_settings_public.scope
      on_unauthenticated_request = var.oidc_settings_public.on_unauthenticated_request
    }
  }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_public.arn
  }
}

data "aws_network_interface" "network_interface" {
  depends_on = [
    aws_vpc_endpoint.vpc_endpoint
  ]
  id = element(tolist(toset(aws_vpc_endpoint.vpc_endpoint.network_interface_ids)), 0)
}

resource "aws_lb_target_group_attachment" "alb_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group_public.arn
  target_id        = data.aws_network_interface.network_interface.private_ip
  port             = 80
  depends_on = [
    aws_vpc_endpoint.vpc_endpoint
  ]
}

resource "aws_route53_record" "private_record" {
  zone_id = var.private_hosted_zone_id
  name    = var.private_subdomain_url
  type    = "A"

  alias {
    name                   = aws_lb.alb_private.dns_name
    zone_id                = aws_lb.alb_private.zone_id
    evaluate_target_health = true
  }

}
resource "aws_route53_record" "public_record" {
  zone_id = var.public_hosted_zone_id
  name    = var.public_subdomain_url
  type    = "A"

  alias {
    name                   = aws_lb.alb_public.dns_name
    zone_id                = aws_lb.alb_public.zone_id
    evaluate_target_health = true
  }

}



// add another target group private alb 80