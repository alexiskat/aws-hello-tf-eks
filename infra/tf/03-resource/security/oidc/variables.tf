variable "client_id_list" {
  description = "A list of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. (This is the value that's sent as the client_id parameter on OAuth requests.)"
  type        = list(string)
}

variable "thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  type        = list(string)
}

variable "url" {
  description = "The URL of the identity provider. Corresponds to the iss claim."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the openid provider."
  type        = map(string)
  default     = {}
}