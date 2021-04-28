output "url" {
  value       = module.queue.url
  description = "The SQS Queue Url"
}

output "arn" {
  value       = module.queue.arn
  description = "The SQS Queue Arn"
}

output "receiver_policy" {
  value       = module.queue.receiver_policy
  description = "Receiver Policy Arn"
}

output "sender_policy" {
  value       = module.queue.sender_policy
  description = "Sender Policy Arn"
}
