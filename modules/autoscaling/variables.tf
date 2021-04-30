variable "cluster" {
  description = "ECS Cluster name"
  type        = string
}

variable "service" {
  description = "ECS Service Name"
  type        = string
}

variable "queue" {
  description = "The Queue name"
  type        = string
}

variable "path" {
  description = "Prefix name"
  type        = string
}
