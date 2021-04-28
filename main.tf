module "queue" {
  source = "./modules/sqs"

  name = "testqueue"
  is_fifo = true
}