# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set in the module block when using this module.
# -----------------------------------------------------------------------------
variable "name" {
  description = "Queue name"
  type        = string
}

# -----------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have default values and don't have to be set to use this module.
# You may set these variables to override their default values.
# -----------------------------------------------------------------------------

variable "is_fifo" {
  description = "Queue is First In First Out"
  type        = bool
  default     = false
}

variable "path" {
  description = "Path where the resources will be created"
  type        = string
  default     = ""
}
