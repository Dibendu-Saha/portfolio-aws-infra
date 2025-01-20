provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

resource "aws_acm_certificate" "certificate" {
  provider                  = aws.us_east_1
  domain_name               = "dibendusaha.com"
  subject_alternative_names = ["www.dibendusaha.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}