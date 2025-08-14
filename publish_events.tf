# Requries S3 bucket and KMS key to already be craeted in Logging & Audit account
resource "aws_guardduty_publishing_destination" "itgix_audit_account" {
  count = var.guardduty_organization_security_account ? 1 : 0

  detector_id = var.guardduty_detector_id // passed from mgmt account

  destination_arn = var.guardduty_findings_central_s3_bucket_arn
  kms_key_arn     = var.guardduty_findings_central_s3_bucket_kms_key_arn
}
