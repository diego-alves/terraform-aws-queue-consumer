output "queue" {
  value       = module.sqs.queue
  description = "The SQS Queue"
}


output "send_policy" {
  value       = module.sqs.send_policy
  description = "Sender Policy Arn"
}

output "image_url" {
  value = module.ecs.image_url
  description = "Repository Image URL"
}