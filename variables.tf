# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set in the module block when using this module.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Project name"
  type        = string
}

variable "cluster" {
  description = "ECS cluster name"
  type        = string
}

# -----------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have default values and don't have to be set to use this module.
# You may set these variables to override their default values.
# -----------------------------------------------------------------------------

variable "app_version" {
  description = "Consumer Version"
  type        = string
  default     = "latest"
}

variable "path" {
  description = "Path where the resources will be created"
  type        = string
  default     = ""
}
