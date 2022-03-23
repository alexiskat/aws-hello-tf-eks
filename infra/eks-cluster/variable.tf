variable "env" {
  description = "The environment this will be run in [prod|preprod|dev]"
  type        = string
  validation {
    condition     = can(regex("^(prod|preprod|dev)$", var.env))
    error_message = "The environment variable can only be set to [prod|preprod|dev]."
  }
}