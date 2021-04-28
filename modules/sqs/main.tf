resource "aws_sqs_queue" "this" {
  name       = join("", [replace(var.path,"/","-"), var.name, (var.is_fifo ? ".fifo" : "")])
  fifo_queue = var.is_fifo
}

resource "aws_iam_policy" "receiver" {
  name        = "${var.name}ReceivePolicy"
  description = "Receive and Delete Message for queue ${aws_sqs_queue.this.name}"
  path        = "/${var.path}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage"
        ],
        "Resource" : aws_sqs_queue.this.arn
      }
    ]
  })

}

resource "aws_iam_policy" "sender" {
  name        = "${var.name}SendPolicy"
  description = "Sends Mesage for queue ${aws_sqs_queue.this.name}"
  path        = "/${var.path}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : aws_sqs_queue.this.arn
      }
    ]
  })

}
