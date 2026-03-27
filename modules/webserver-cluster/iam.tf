resource "aws_iam_role" "instance" {
  name_prefix = "${var.cluster_name}-ec2-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-ec2-role"
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "cloudwatch-logs-app"
  role = aws_iam_role.instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "WriteAppLogGroup"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "${aws_cloudwatch_log_group.app.arn}:*"
      },
      {
        Sid    = "DescribeLogStreams"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
        ]
        Resource = aws_cloudwatch_log_group.app.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "instance" {
  name_prefix = "${var.cluster_name}-profile-"
  role        = aws_iam_role.instance.name

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-instance-profile"
  })
}
