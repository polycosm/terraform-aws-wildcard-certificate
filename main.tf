/* Create the wildcard certificate.
 */
resource "aws_acm_certificate" "wildcard" {
  domain_name               = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

/* Create DNS validation records for each certificate.
 */
resource "aws_route53_record" "validation" {
  for_each = {
    for item in aws_acm_certificate.wildcard.domain_validation_options : item.domain_name => {
      name   = item.resource_record_name
      record = item.resource_record_value
      type   = item.resource_record_type
    }
    # wildcard domains are validated as part of the root
    if item.domain_name != "*.${var.root_domain_name}"
  }

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = var.zone.id
}

/* Validate that DNS verification succeedd.
 */
resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [
    for item in aws_route53_record.validation :
    item.fqdn
  ]
}
