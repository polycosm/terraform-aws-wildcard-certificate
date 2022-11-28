# terraform-aws-wildcard-certificate

Terraform module to create an ACM wildcard certificate.

The resulting certificate will support both the root domain name (e.g. `example.com`) and
all subdomains one level beneath the root (e.g. `foo.example.com`); such certificates are
expecially useful when using host-based routing behind a shared load-balancer.

Assumes that Route53 records are managed in the same account as the certificates.
