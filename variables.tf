variable "aws_region" {
  type        = string
  description = "Region where KMS key and S3 bucket for Guardduty findings are created"
}

variable "guardduty_tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  default     = {}
  type        = map(string)
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

variable "disable_email_notification" {
  type        = bool
  default     = true
  description = "(Optional) Boolean whether an email notification is sent to the accounts when new member accounts are registered. Defaults to false"
}

# Runtime monitoring options - these are separate because they are created with the same AWS resources but have different fields depending on what is being monitored
variable "enable_guardduty_runtime_monitoring" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty Runtime Monitoring at the organization level to detect potentially malicious activity on compute workloads."
}

variable "enable_guardduty_eks_addon_management" {
  type        = bool
  default     = false
  description = "Enable GuardDuty-managed EKS add-on deployment for runtime monitoring of Amazon EKS workloads. Requires GuardDuty runtime monitoring to be enabled."
}

variable "enable_guardduty_ec2_agent_management" {
  type        = bool
  default     = false
  description = "Enable GuardDuty-managed agent deployment for runtime monitoring on Amazon EC2 instances. Requires GuardDuty runtime monitoring to be enabled."
}

variable "enable_guardduty_ecs_fargate_agent_management" {
  type        = bool
  default     = false
  description = "Enable GuardDuty-managed agent deployment for runtime monitoring of Amazon ECS tasks running on AWS Fargate. Requires GuardDuty runtime monitoring to be enabled."
}

# Additional scanning features
variable "enable_s3_data_events_scanning" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty monitoring for S3 data events, detecting suspicious object-level API activity such as unauthorized access or data exfiltration attempts."
}

variable "enable_eks_audit_logs_scanning" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty analysis of Amazon EKS control plane audit logs to detect suspicious or malicious Kubernetes API activity."
}

variable "enable_ebs_malware_protection_scanning" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty malware protection for Amazon EBS volumes by scanning newly created and attached volumes for known malware."
}

variable "enable_rds_login_events_scanning" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty monitoring of Amazon RDS login activity to detect anomalous or potentially malicious database authentication behavior."
}

variable "enable_lambda_network_logs_scanning" {
  type        = bool
  default     = false
  description = "Enable Amazon GuardDuty analysis of AWS Lambda network activity to detect suspicious outbound connections or unexpected network behavior."
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
