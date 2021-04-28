resource "aws_sqs_queue" "this" {
  name = join("", [var.name, (var.is_fifo ? ".fifo" : "" )])
  fifo_queue = var.is_fifo
}