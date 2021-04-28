module "sqs" {
  source = "./modules/sqs"

  name = var.name
  is_fifo = true
}

module "task" {
  source = "./modules/task"

  name = var.name
  queue = module.sqs.queue
}