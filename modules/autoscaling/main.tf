resource "aws_appautoscaling_target" "target" {
  max_capacity       = var.max
  min_capacity       = var.min
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  # role_arn           = "arn:aws:iam::760373735544:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_policy" "policy" {
  name               = join("", [var.path, var.service])
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.cooldown
    metric_aggregation_type = "Average"

    step_adjustment { //add 1 task if metric >= threshold
      metric_interval_lower_bound = var.threshold
      scaling_adjustment          = 1
    }

    step_adjustment { //remove 1 task if metric < threshold
      metric_interval_upper_bound = var.threshold
      scaling_adjustment          = -1
    }

  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name = join("", [replace(var.path, "/", "-"), var.service])

  // select the queue metric
  namespace   = "AWS/SQS"
  metric_name = "ApproximateNumberOfMessagesVisible"
  dimensions = {
    QueueName = var.queue
  }

  // metric is the average of 1 evalution on each 60 seconds
  evaluation_periods  = 1
  period              = 60
  statistic           = "Average"

  // threshold has to be -1 because the operator is not equal or
  // This way the step bound can be set corretly.
  // Ex: if threshold = 1 then metric > 0 sends the alert
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold - 1 

  // sets the alarm action
  alarm_description = "Check Number of Mesages in the Queue"
  alarm_actions = [
    aws_appautoscaling_policy.policy.arn
  ]
  ok_actions = [
    aws_appautoscaling_policy.policy.arn
  ]
}
