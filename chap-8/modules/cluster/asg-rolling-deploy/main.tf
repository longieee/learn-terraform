terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_ec2_instance_type" "instance" {
  instance_type = var.instance_type
}

/* --------------------------------- Locals --------------------------------- */
locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

/* -------------------------------------------------------------------------- */
/*                               Security groups                              */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "instace" {
  name = "${var.cluster_name}-instance"
}

resource "aws_security_group_rule" "allow_all_inbound_webserver" {
  type              = "ingress"
  security_group_id = aws_security_group.instace.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

/* -------------------------------------------------------------------------- */
/*                                     ASG                                    */
/* -------------------------------------------------------------------------- */
resource "aws_launch_configuration" "example" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instace.id]

  user_data = var.user_data

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS free tier"
    }
  }
}

resource "aws_autoscaling_group" "example" {
  # Commented parts are for naive way of implementing zero-downtime

  # Explicitly depend on the launch configuration's name so each time it's 
  # replaced, this ASG is also replaced
  # name = "${var.cluster_name}-${aws_launch_configuration.example.name}"

  name                 = var.cluster_name
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = var.subnet_ids

  lifecycle {
    postcondition {
      # You can use this special syntax `self` solely in postcondition, connection, and provisioner blocks
      condition     = length(self.availability_zones) > 1
      error_message = "You must use more than on AZ for high availability!"
    }
  }

  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  # Wait for at least this many instances to pass health checks before 
  # considering the ASG deployment complete
  # min_elb_capacity = var.min_size

  # When replacing this ASG, create the replacement first, and only delete the 
  # original after
  # lifecycle {
  #   create_before_destroy = true
  # }

  # New way of handling zero-downtime: Instance Refresh
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-terraform-asg-example"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.asg_custom_tags :
      key => value
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                            Autoscaling schedules                           */
/* -------------------------------------------------------------------------- */
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "${var.cluster_name}-scale-out-during-business-hours"
  min_size              = 2
  max_size              = 5
  desired_capacity      = 5
  recurrence            = "0 9 * * *"

  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "${var.cluster_name}-scale-in-at-night"
  min_size              = 2
  max_size              = 5
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = aws_autoscaling_group.example.name
}


/* -------------------------------------------------------------------------- */
/*                                   Alarms                                   */
/* -------------------------------------------------------------------------- */
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}
