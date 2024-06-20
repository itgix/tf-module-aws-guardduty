If module is called in organization management account it will enable Guardduty for the whole organization, configure which options to scan for and add member accounts

```
module "guardduty_admin" {
  source                                    = "../modules/guardduty"
  guardduty_organization_management_account = var.guardduty_organization_management_account # true

  # account id of the shared services account
  # TODO: figure out how to get those dynamically from the state of each application account
  # List of all application accounts that need to be scanned by GuardDuty 
  organization_management_account_id = data.aws_caller_identity.current.account_id
  organization_member_account_ids    = [767398095708, 905418051897, 381492288235]

  enable_guardduty_s3_logs_scanning        = var.enable_guardduty_s3_logs_scanning # true
  enable_guardduty_kubenetes_logs_scanning = var.enable_guardduty_kubenetes_logs_scanning # false
  enable_guardduty_ec2_malware_protection  = var.enable_guardduty_ec2_malware_protection # true

  # TODO: figure out how to pass those ARNs from the Audit account's TF state where they are created
  # Requries S3 bucket and KMS key to already be craeted in Logging & Audit account
  # bucket names should match exactly as with where they are created (in the logging and audit account)
  guardduty_findings_central_s3_bucket_arn = "arn:aws:s3:::guardduty-${var.project}"
  # TODO: can we configure this to be referancable by alias instead of arn ? 
  #guardduty_findings_central_s3_bucket_kms_key_arn = "guardduty-${var.project}-bucket-access-logs"
  guardduty_findings_central_s3_bucket_kms_key_arn = "arn:aws:kms:eu-central-1:590183971189:key/a059c161-4225-4d55-b399-6ada39ab0c48"
  guardduty_finding_publishing_frequency           = var.guardduty_finding_publishing_frequency # suppports SIX_HOURS (default), FIFTEEN_MINUTES, ONE_HOUR

  guardduty_tags = {
    guardduty_config = "delegated-admin-account"
  }
}
```

If module is called in logging & audit account it will create the necessary S3 bucket, KMS and policies that will store the aggregated guarduty findings from all other accounts. This is the bucket where findings can be audited and archived in a central place

```
module "guardduty_audit" {
  source                               = "../modules/guardduty"
  guardduty_organization_audit_account = var.guardduty_organization_audit_account # true
  aws_region                           = var.aws_region

  # bucket names should match exactly as with where they are used (in the management account where guardduty is enabled for the whole organization)
  guardduty_s3_bucket_name            = "guardduty-${var.project}"
  guardduty_s3_access_log_bucket_name = "guardduty-${var.project}-bucket-access-logs"

  organization_management_account_id = "905418229353"
  organization_audit_account_id      = data.aws_caller_identity.current.account_id

  s3_bucket_enable_object_transition_to_glacier     = var.s3_bucket_enable_object_transition_to_glacier # true
  s3_bucket_object_transition_to_glacier_after_days = var.s3_bucket_object_transition_to_glacier_after_days # 365

  s3_bucket_enable_object_deletion     = var.s3_bucket_enable_object_deletion # false
  s3_bucket_object_deletion_after_days = var.s3_bucket_object_deletion_after_days # 1095

  guardduty_tags = {
    guardduty_config = "audit-and-archival-account"
  }
}
```
