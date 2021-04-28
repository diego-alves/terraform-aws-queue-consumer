output "url" {
  value       = aws_sqs_queue.this.id
  description = "The queue public url"
}

output "arn" {
  value       = aws_sqs_queue.this.arn
  description = "The queue arn"
}

output "receiver_policy" {
  value       = aws_iam_policy.receiver.arn
  description = "The IAM policy Receiver Arn, to attach on Consumer's Role"
}

output "sender_policy" {
  value       = aws_iam_policy.sender.arn
  description = "The IAM policy Sender Arn, to attach on Producer's Role"
}
