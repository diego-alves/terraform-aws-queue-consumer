# Autoscaling ECS Service on Queue Messages

This folder contains a [Terraform](https://terraform.io) module to setup an [Application Autoscaling](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html) on top of a [ECS Service](https://aws.amazon.com/ecs) based on the number of available messages on a [SQS Queue](https://aws.amazon.com/sqs/).

## How to use this module

This folder defines a [Terraform Module](https://www.terraform.io/docs/language/modules/index.html), which you can use in your code adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "autoscale_service" {
  source = "github.com/diego-alves/terraform-aws-queue-consumer//modules/autoscaling?ref=0.0.1"

  queue   = "https://sqs.us-east-1.amazonaws.com/123456789/my-queue"
  cluster = "ecs-cluster"
  service = "queue-consumer"

}
```

Note the following parameters:

- `queue`: The SQS Queue Url
- `cluster`: The ECS cluster name
- `service`: The ECS service name

You can find the other parameters in [variables.tf](./variables.tf)
