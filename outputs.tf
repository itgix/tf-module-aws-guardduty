output "guardduty_bucket_arn" {
  value = try(aws_s3_bucket.guardduty_findings[0].arn, null)
}
