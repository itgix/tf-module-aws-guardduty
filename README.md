The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS GuardDuty Terraform Module

This module deploys Amazon GuardDuty with multi-account organization support, S3 findings export, KMS encryption, SNS notifications, and configurable detection features.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- GuardDuty detector with configurable features
- S3 bucket for findings export (with lifecycle policies and Glacier transition)
- KMS key for findings encryption
- SNS topic for GuardDuty notifications
- Member account associations
- *(Optional)* Runtime monitoring for EKS, EC2, and ECS Fargate

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `aws_region` | Region where KMS key and S3 bucket are created | `string` | — | yes |
| `guardduty_tags` | Tags to apply to all resources | `map(string)` | `{}` | no |
| `guardduty_organization_audit_account` | Set to true when running from organization audit account | `bool` | `false` | no |
| `guardduty_organization_security_account` | Set to true when running from organization security account | `bool` | `false` | no |
| `organization_security_account_id` | The account ID of the organization security account | `string` | `""` | no |
| `organization_member_account_ids` | List of member account IDs where GuardDuty will be enabled | `list(any)` | `[]` | no |
| `organization_audit_account_id` | The account ID of the organization audit account | `string` | `""` | no |
| `disable_email_notification` | Whether to disable email notification for new members | `bool` | `true` | no |
| `enable_guardduty_runtime_monitoring` | Enable GuardDuty Runtime Monitoring | `bool` | `false` | no |
| `enable_guardduty_eks_addon_management` | Enable GuardDuty-managed EKS add-on for runtime monitoring | `bool` | `false` | no |
| `enable_guardduty_ec2_agent_management` | Enable GuardDuty-managed agent for EC2 runtime monitoring | `bool` | `false` | no |
| `enable_guardduty_ecs_fargate_agent_management` | Enable GuardDuty-managed agent for ECS Fargate runtime monitoring | `bool` | `false` | no |
| `enable_s3_data_events_scanning` | Enable monitoring for S3 data events | `bool` | `false` | no |
| `enable_eks_audit_logs_scanning` | Enable analysis of EKS audit logs | `bool` | `false` | no |
| `enable_ebs_malware_protection_scanning` | Enable malware protection for EBS volumes | `bool` | `false` | no |
| `enable_rds_login_events_scanning` | Enable monitoring of RDS login activity | `bool` | `false` | no |
| `enable_lambda_network_logs_scanning` | Enable analysis of Lambda network activity | `bool` | `false` | no |
| `guardduty_findings_central_s3_bucket_kms_key_arn` | ARN of KMS key for GuardDuty S3 bucket | `string` | `""` | no |
| `guardduty_s3_kms_key_alias` | Alias name for the KMS key | `string` | `"alias/guardduty-findings-s3-bucket"` | no |
| `guardduty_s3_bucket_name` | S3 bucket name for findings | `string` | `""` | no |
| `guardduty_detector_id` | GuardDuty detector ID | `string` | `""` | no |
| `guardduty_findings_central_s3_bucket_arn` | ARN of S3 bucket in Audit account for findings | `string` | `""` | no |
| `s3_bucket_versioning_enabled` | Enable versioning on S3 bucket | `string` | `"Enabled"` | no |
| `s3_bucket_enable_object_deletion` | Enable object deletion in GuardDuty bucket | `string` | `"Enabled"` | no |
| `s3_bucket_object_deletion_after_days` | Days after which objects are deleted | `number` | `1095` | no |
| `s3_bucket_enable_object_transition_to_glacier` | Enable Glacier transition | `string` | `"Enabled"` | no |
| `s3_bucket_object_transition_to_glacier_after_days` | Days after which objects transition to Glacier | `number` | `365` | no |
| `guardduty_notification_mail` | Email address for security notifications | `string` | `"aws-landing-zones@itgix.com"` | no |
| `invite_member_account` | Whether to invite accounts as members | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `guardduty_s3_bucket_arn` | GuardDuty findings S3 bucket ARN |
| `guardduty_s3_kms_arn` | GuardDuty KMS key ARN |

## Usage Example

```hcl
module "guardduty" {
  source = "path/to/tf-module-aws-guardduty"

  aws_region = "eu-central-1"

  guardduty_organization_security_account = true
  organization_security_account_id        = "111111111111"
  organization_audit_account_id           = "222222222222"

  organization_member_account_ids = [
    "333333333333",
    "444444444444"
  ]

  enable_s3_data_events_scanning     = true
  enable_eks_audit_logs_scanning     = true
  enable_guardduty_runtime_monitoring = true

  guardduty_s3_bucket_name = "my-org-guardduty-findings"

  guardduty_tags = {
    Environment = "security"
    ManagedBy   = "terraform"
  }
}
```
