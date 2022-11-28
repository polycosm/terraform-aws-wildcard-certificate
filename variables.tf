variable "root_domain_name" {
  description = "The root domain name to use for the wildcard certificate."
  type        = string
}

variable "zone" {
  description = "The Route53 zone in which to create the validation records."
  type = object({
    id = string
  })
}
