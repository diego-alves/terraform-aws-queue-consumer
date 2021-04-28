output "url" {
  value = aws_sqs_queue.this.id
  description = "The queue public url"
}

output "arn" {
  value = aws_sqs_queue.this.arn
  description = "The queue arn"
}