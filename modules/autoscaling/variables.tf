# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set in the module block when using this module.
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have default values and don't have to be set to use this module.
# You may set these variables to override their default values.
# -----------------------------------------------------------------------------

variable "path" {
  description = "Prefix name"
  type        = string
  default     = ""
}

variable "min" {
  description = "The min number of running tasks"
  type        = number
  default     = 0
}

variable "max" {
  description = "The max number of running tasks"
  type        = number
  default     = 1
}

variable "cooldown" {
  description = "Time in secods between scaling activities"
  type        = number
  default     = 300 // 5 minutes
}

variable "threshold" {
  description = "The threshold value, messages >= add task, messages < remove task"
  type        = number
  default     = 1
}
