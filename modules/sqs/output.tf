output "queue" {
  value = {
    url  = aws_sqs_queue.this.id
    arn  = aws_sqs_queue.this.arn
    name = aws_sqs_queue.this.name
  }
  description = "The queue with url and arn"
}

output "receiver_policy" {
  value       = aws_iam_policy.receiver.arn
  description = "The IAM policy Receiver Arn, to attach on Consumer's Role"
}

output "sender_policy" {
  value       = aws_iam_policy.sender.arn
  description = "The IAM policy Sender Arn, to attach on Producer's Role"
}
