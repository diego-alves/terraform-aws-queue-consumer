# ------------------------------------------------------------------------------
# DATA
# ------------------------------------------------------------------------------
module "data" {
  source  = "diego-alves/data/aws"
  version = "0.0.5"
}

# ------------------------------------------------------------------------------
# SQS
# ------------------------------------------------------------------------------
module "sqs" {
  source = "./modules/sqs"

  name    = var.name
  path    = var.path
  is_fifo = false
}

# ------------------------------------------------------------------------------
# ECS
# ------------------------------------------------------------------------------
module "ecs" {
  source = "./modules/ecs"

  name      = var.name
  cluster   = var.cluster
  path      = var.path
  queue     = module.sqs.queue
  image_tag = var.app_version
  vpc_id    = module.data.vpc_id
  subnets   = module.data.subnet_ids.app

  environment = {
    QUEUE_URL  = module.sqs.queue.url
    BOTO_PROXY = "http://pagseguro.proxy.srv.intranet:80"
  }
}

# ------------------------------------------------------------------------------
# AUTO SCALING
# ------------------------------------------------------------------------------
module "asg" {
  source = "./modules/autoscaling"

  service = var.name
  path    = var.path
  cluster = var.cluster
  queue   = module.sqs.queue.name

}
