# create certificate 
resource "aws_acm_certificate" "cert" {
  provider          = aws.global
  domain_name       = var.domain_name
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

# validate cert:
resource "aws_route53_record" "certvalidation" {
  for_each = {
    for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

# certificate validation
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.global
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.certvalidation : r.fqdn]
}