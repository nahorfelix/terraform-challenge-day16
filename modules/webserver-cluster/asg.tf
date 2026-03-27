resource "aws_launch_template" "web" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = local.resolved_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.instance.name
  }

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    cluster_name = var.cluster_name
    server_port  = var.server_port
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-instance"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name_prefix         = "${var.cluster_name}-asg-"
  vpc_zone_identifier = local.subnet_ids
  target_group_arns   = [aws_lb_target_group.http.arn]

  # ELB health checks — not EC2-only — per production checklist
  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size = local.min_size
  max_size = local.max_size

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = local.max_size >= local.min_size
      error_message = "max_size must be greater than or equal to min_size."
    }
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count = local.autoscaling_enabled ? 1 : 0

  name                   = "${var.cluster_name}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
