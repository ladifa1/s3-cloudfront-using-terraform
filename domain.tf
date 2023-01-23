# create records for cloudfront
resource "aws_route53_record" "cloudfront_staging" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = var.route53_name
  type    = var.route53_record_type

  alias {
    name                   = aws_cloudfront_distribution.network.domain_name
    zone_id                = aws_cloudfront_distribution.network.hosted_zone_id
    evaluate_target_health = true
  }
}