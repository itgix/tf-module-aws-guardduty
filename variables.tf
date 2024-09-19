variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Region where KMS key and S3 bucket for Guardduty findings are created"
}

variable "guardduty_tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  default = {
  }
}

variable "guardduty_organization_management_account" {
  type        = bool
  default     = false
  description = "Set to true when running from organization management account to configure the Guardduty delegated admin"
}

variable "guardduty_organization_audit_account" {
  type        = bool
  default     = false
  description = "Set to true when running from organization audit account to configure S3 bucket, KMS key and policies for storing and archiving Guardduty findings in the central audit account"
}

variable "guardduty_organization_security_account" {
  type        = bool
  default     = false
  description = "Set to true when running from organization security account to configure the Guardduty in the organization and invite member accounts"
}

variable "enable_guardduty_s3_logs_scanning" {
  type        = bool
  default     = true
  description = "Wether to enable scanning of S3 logs"
}

variable "enable_guardduty_kubenetes_logs_scanning" {
  type        = bool
  default     = false
  description = "Wether to enable scanning of Kubernetes logs"
}

variable "enable_guardduty_ec2_malware_protection" {
  type        = bool
  default     = true
  description = "Wether to enable malware scanning of EC2 instance EBS volumes"
}

variable "organization_security_account_id" {
  type        = string
  description = "The account ID of the organization security account"
  default     = ""
}

variable "organization_member_account_ids" {
  type        = list(any)
  description = "List of member account IDs where guarduty will be enabled"
  default     = []
}

variable "organization_audit_account_id" {
  type        = string
  description = "The account ID of the organization audit account"
  default     = ""
}

variable "guardduty_finding_publishing_frequency" {
  type        = string
  default     = "SIX_HOURS"
  description = "(Optional) Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty primary account and cannot be modified, otherwise defaults to SIX_HOURS. For standalone and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and primary accounts: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS"
}

variable "disable_email_notification" {
  type        = bool
  default     = true
  description = "(Optional) Boolean whether an email notification is sent to the accounts when new member accounts are registered. Defaults to false"
}

# KMS
variable "guardduty_findings_central_s3_bucket_kms_key_arn" {
  type        = string
  description = "ARN of KMS key associated with Guardduty S3 bucket"
  default     = ""
}

variable "guardduty_s3_kms_key_alias" {
  type        = string
  description = "Alias name to configured on KMS key"
  default     = "alias/guardduty-findings-s3-bucket"
}

# S3 Bucket
variable "guardduty_s3_bucket_name" {
  type    = string
  default = ""
}

variable "guardduty_detector_id" {
  type        = string
  default     = ""
  description = "Guardduty detector ID"
}

variable "guardduty_findings_central_s3_bucket_arn" {
  type        = string
  description = "ARN of S3 bucket in Audit account where all guarduty events will be stored"
  default     = ""
}

variable "guardduty_s3_access_log_bucket_name" {
  type    = string
  default = ""
}

variable "s3_bucket_versioning_enabled" {
  type        = string
  default     = "Enabled"
  description = "Enabled or Disabled - if versioning on S3 bucket should be enabled"
}

variable "s3_bucket_enable_object_deletion" {
  type        = string
  default     = "Enabled"
  description = "Enabled or Disabled - If objects in guardduty bucket should be deleted"
}

variable "s3_bucket_object_deletion_after_days" {
  type        = number
  default     = 1095
  description = "After how long show objects in guardduty bucket be deleted"
}

variable "s3_bucket_enable_object_transition_to_glacier" {
  type        = string
  default     = "Enabled"
  description = "Enabled or Disabled - If objects in guardduty bucket should be transition to glacier"
}

variable "s3_bucket_object_transition_to_glacier_after_days" {
  type        = number
  default     = 365
  description = "After how long show objects in guardduty bucket be transitioned to glacier"
}

variable "guardduty_notification_mail" {
  type        = string
  default     = "aws-landing-zones@itgix.com"
  description = "(Optional) e-mail address that can be provided to receive updates about security issues"
}

variable "invite_member_account" {
  type        = bool
  default     = false
  description = "(Optional) Boolean whether to invite the account to Security Hub as a member. Defaults to false."
}
