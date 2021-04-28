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
