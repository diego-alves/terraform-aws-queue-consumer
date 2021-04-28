module "sqs" {
  source = "./modules/sqs"

  name    = var.name
  path    = var.path
  is_fifo = true
}

module "task" {
  source = "./modules/task"

  name  = var.name
  queue = module.sqs.queue
}
