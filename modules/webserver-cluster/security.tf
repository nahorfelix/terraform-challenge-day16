resource "aws_security_group" "instance" {
  name_prefix = "${var.cluster_name}-inst-"
  description = "Instances for ${var.cluster_name}; ingress only from ALB."
  vpc_id      = local.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-instance-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance_from_alb" {
  security_group_id        = aws_security_group.instance.id
  type                     = "ingress"
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  description              = "Application port from ALB only"
}

resource "aws_security_group_rule" "instance_egress" {
  security_group_id = aws_security_group.instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress to internet (updates, APIs)"
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.cluster_name}-alb-"
  description = "ALB for ${var.cluster_name}"
  vpc_id      = local.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-alb-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_http_public" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Public HTTP to load balancer (tighten in production)"
}

resource "aws_security_group_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ALB to targets"
}
