output "url" {
  value = module.queue.url
  description = "The SQS Queue Url"
}

output "arn" {
  value = module.queue.arn
  description = "The SQS Queue Arn"
}