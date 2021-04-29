# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set in the module block when using this module.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Project name"
  type        = string
}

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
