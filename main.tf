module "sqs" {
  source = "./modules/sqs"

  name    = var.name
  path    = var.path
  is_fifo = false
}

module "task" {
  source = "./modules/task"

  name  = var.name
  queue = module.sqs.queue
  image_tag = var.app_version

  environment = {
    QUEUE_URL = module.sqs.queue.url
    BOTO_PROXY = "http://pagseguro.proxy.srv.intranet:80"
  }
}
