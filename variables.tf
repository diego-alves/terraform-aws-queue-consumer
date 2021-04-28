# -----------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set in the module block when using this module.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Project name"
  type        = string
}

variable "path" {
  description = "Path where the resources will be created"
  type        = string
  default     = ""
}
