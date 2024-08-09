output "guardduty_bucket_arn" {
  value = try(aws_s3_bucket.guardduty_findings[0].arn, null)
}

output "guardduty_s3_kms_arn" {
  value = try(aws_kms_key.guardduty[0].arn, null)
}
