output "queue" {
  value       = module.sqs.queue
  description = "The SQS Queue"
}

output "receiver_policy" {
  value       = module.sqs.receiver_policy
  description = "Receiver Policy Arn"
}

output "sender_policy" {
  value       = module.sqs.sender_policy
  description = "Sender Policy Arn"
}

output "image_url" {
  value = module.task.image_url
  description = "Repository Image URL"
}