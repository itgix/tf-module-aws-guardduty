The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_member.members](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member) | resource |
| [aws_guardduty_organization_configuration_feature.ebs_malware_protection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_organization_configuration_feature.eks_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_organization_configuration_feature.lambda_network_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_organization_configuration_feature.rds_login_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_organization_configuration_feature.runtime_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_organization_configuration_feature.s3_data_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration_feature) | resource |
| [aws_guardduty_publishing_destination.itgix_audit_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |
| [aws_kms_alias.kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.guardduty_findings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.guardduty_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guardduty_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region where KMS key and S3 bucket for Guardduty findings are created | `string` | n/a | yes |
| <a name="input_disable_email_notification"></a> [disable\_email\_notification](#input\_disable\_email\_notification) | (Optional) Boolean whether an email notification is sent to the accounts when new member accounts are registered. Defaults to false | `bool` | `true` | no |
| <a name="input_enable_ebs_malware_protection_scanning"></a> [enable\_ebs\_malware\_protection\_scanning](#input\_enable\_ebs\_malware\_protection\_scanning) | Enable Amazon GuardDuty malware protection for Amazon EBS volumes by scanning newly created and attached volumes for known malware. | `bool` | `false` | no |
| <a name="input_enable_eks_audit_logs_scanning"></a> [enable\_eks\_audit\_logs\_scanning](#input\_enable\_eks\_audit\_logs\_scanning) | Enable Amazon GuardDuty analysis of Amazon EKS control plane audit logs to detect suspicious or malicious Kubernetes API activity. | `bool` | `false` | no |
| <a name="input_enable_guardduty_ec2_agent_management"></a> [enable\_guardduty\_ec2\_agent\_management](#input\_enable\_guardduty\_ec2\_agent\_management) | Enable GuardDuty-managed agent deployment for runtime monitoring on Amazon EC2 instances. Requires GuardDuty runtime monitoring to be enabled. | `bool` | `false` | no |
| <a name="input_enable_guardduty_ecs_fargate_agent_management"></a> [enable\_guardduty\_ecs\_fargate\_agent\_management](#input\_enable\_guardduty\_ecs\_fargate\_agent\_management) | Enable GuardDuty-managed agent deployment for runtime monitoring of Amazon ECS tasks running on AWS Fargate. Requires GuardDuty runtime monitoring to be enabled. | `bool` | `false` | no |
| <a name="input_enable_guardduty_eks_addon_management"></a> [enable\_guardduty\_eks\_addon\_management](#input\_enable\_guardduty\_eks\_addon\_management) | Enable GuardDuty-managed EKS add-on deployment for runtime monitoring of Amazon EKS workloads. Requires GuardDuty runtime monitoring to be enabled. | `bool` | `false` | no |
| <a name="input_enable_guardduty_runtime_monitoring"></a> [enable\_guardduty\_runtime\_monitoring](#input\_enable\_guardduty\_runtime\_monitoring) | Enable Amazon GuardDuty Runtime Monitoring at the organization level to detect potentially malicious activity on compute workloads. | `bool` | `false` | no |
| <a name="input_enable_lambda_network_logs_scanning"></a> [enable\_lambda\_network\_logs\_scanning](#input\_enable\_lambda\_network\_logs\_scanning) | Enable Amazon GuardDuty analysis of AWS Lambda network activity to detect suspicious outbound connections or unexpected network behavior. | `bool` | `false` | no |
| <a name="input_enable_rds_login_events_scanning"></a> [enable\_rds\_login\_events\_scanning](#input\_enable\_rds\_login\_events\_scanning) | Enable Amazon GuardDuty monitoring of Amazon RDS login activity to detect anomalous or potentially malicious database authentication behavior. | `bool` | `false` | no |
| <a name="input_enable_s3_data_events_scanning"></a> [enable\_s3\_data\_events\_scanning](#input\_enable\_s3\_data\_events\_scanning) | Enable Amazon GuardDuty monitoring for S3 data events, detecting suspicious object-level API activity such as unauthorized access or data exfiltration attempts. | `bool` | `false` | no |
| <a name="input_guardduty_detector_id"></a> [guardduty\_detector\_id](#input\_guardduty\_detector\_id) | Guardduty detector ID | `string` | `""` | no |
| <a name="input_guardduty_findings_central_s3_bucket_arn"></a> [guardduty\_findings\_central\_s3\_bucket\_arn](#input\_guardduty\_findings\_central\_s3\_bucket\_arn) | ARN of S3 bucket in Audit account where all guarduty events will be stored | `string` | `""` | no |
| <a name="input_guardduty_findings_central_s3_bucket_kms_key_arn"></a> [guardduty\_findings\_central\_s3\_bucket\_kms\_key\_arn](#input\_guardduty\_findings\_central\_s3\_bucket\_kms\_key\_arn) | ARN of KMS key associated with Guardduty S3 bucket | `string` | `""` | no |
| <a name="input_guardduty_notification_mail"></a> [guardduty\_notification\_mail](#input\_guardduty\_notification\_mail) | (Optional) e-mail address that can be provided to receive updates about security issues | `string` | `"aws-landing-zones@itgix.com"` | no |
| <a name="input_guardduty_organization_audit_account"></a> [guardduty\_organization\_audit\_account](#input\_guardduty\_organization\_audit\_account) | Set to true when running from organization audit account to configure S3 bucket, KMS key and policies for storing and archiving Guardduty findings in the central audit account | `bool` | `false` | no |
| <a name="input_guardduty_organization_security_account"></a> [guardduty\_organization\_security\_account](#input\_guardduty\_organization\_security\_account) | Set to true when running from organization security account to configure the Guardduty in the organization and invite member accounts | `bool` | `false` | no |
| <a name="input_guardduty_s3_bucket_name"></a> [guardduty\_s3\_bucket\_name](#input\_guardduty\_s3\_bucket\_name) | S3 Bucket | `string` | `""` | no |
| <a name="input_guardduty_s3_kms_key_alias"></a> [guardduty\_s3\_kms\_key\_alias](#input\_guardduty\_s3\_kms\_key\_alias) | Alias name to configured on KMS key | `string` | `"alias/guardduty-findings-s3-bucket"` | no |
| <a name="input_guardduty_tags"></a> [guardduty\_tags](#input\_guardduty\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_invite_member_account"></a> [invite\_member\_account](#input\_invite\_member\_account) | (Optional) Boolean whether to invite the account to Security Hub as a member. Defaults to false. | `bool` | `false` | no |
| <a name="input_organization_audit_account_id"></a> [organization\_audit\_account\_id](#input\_organization\_audit\_account\_id) | The account ID of the organization audit account | `string` | `""` | no |
| <a name="input_organization_member_account_ids"></a> [organization\_member\_account\_ids](#input\_organization\_member\_account\_ids) | List of member account IDs where guarduty will be enabled | `list(any)` | `[]` | no |
| <a name="input_organization_security_account_id"></a> [organization\_security\_account\_id](#input\_organization\_security\_account\_id) | The account ID of the organization security account | `string` | `""` | no |
| <a name="input_s3_bucket_enable_object_deletion"></a> [s3\_bucket\_enable\_object\_deletion](#input\_s3\_bucket\_enable\_object\_deletion) | Enabled or Disabled - If objects in guardduty bucket should be deleted | `string` | `"Enabled"` | no |
| <a name="input_s3_bucket_enable_object_transition_to_glacier"></a> [s3\_bucket\_enable\_object\_transition\_to\_glacier](#input\_s3\_bucket\_enable\_object\_transition\_to\_glacier) | Enabled or Disabled - If objects in guardduty bucket should be transition to glacier | `string` | `"Enabled"` | no |
| <a name="input_s3_bucket_object_deletion_after_days"></a> [s3\_bucket\_object\_deletion\_after\_days](#input\_s3\_bucket\_object\_deletion\_after\_days) | After how long show objects in guardduty bucket be deleted | `number` | `1095` | no |
| <a name="input_s3_bucket_object_transition_to_glacier_after_days"></a> [s3\_bucket\_object\_transition\_to\_glacier\_after\_days](#input\_s3\_bucket\_object\_transition\_to\_glacier\_after\_days) | After how long show objects in guardduty bucket be transitioned to glacier | `number` | `365` | no |
| <a name="input_s3_bucket_versioning_enabled"></a> [s3\_bucket\_versioning\_enabled](#input\_s3\_bucket\_versioning\_enabled) | Enabled or Disabled - if versioning on S3 bucket should be enabled | `string` | `"Enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_s3_bucket_arn"></a> [guardduty\_s3\_bucket\_arn](#output\_guardduty\_s3\_bucket\_arn) | n/a |
| <a name="output_guardduty_s3_kms_arn"></a> [guardduty\_s3\_kms\_arn](#output\_guardduty\_s3\_kms\_arn) | n/a |
<!-- END_TF_DOCS -->
