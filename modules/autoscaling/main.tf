resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 1
  min_capacity       = 0
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  # role_arn           = "arn:aws:iam::760373735544:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_policy" "scaling_policy" {
  name               = join("", [var.path, var.service])
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Average"

    step_adjustment { //add 1 task if >= 1 
      metric_interval_lower_bound = 1.0
      scaling_adjustment          = 1
    }

    step_adjustment { //remove 1 task if < 1
      metric_interval_upper_bound = 1.0
      scaling_adjustment          = -1
    }

  }
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name = join("", [replace(var.path, "/", "-"), var.service])

  // select the queue metric
  namespace   = "AWS/SQS"
  metric_name = "ApproximateNumberOfMessagesVisible"
  dimensions = {
    QueueName = var.queue
  }

  // comparison threshold avg(1 * 60s) >= 1
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 60
  statistic           = "Average"
  threshold           = 0

  // sets the alarm action
  alarm_description = "Check Number of Mesages in the Queue"
  alarm_actions = [
    aws_appautoscaling_policy.scaling_policy.arn
  ]
  ok_actions = [
    aws_appautoscaling_policy.scaling_policy.arn
  ]
}
