# Enable Guardduty in delegated admin account - acc where Guardduty will be managed for the whole organization
# guardduty detector
resource "aws_guardduty_detector" "itgix_primary" {
  count  = var.guardduty_organization_management_account ? 1 : 0
  enable = true

  finding_publishing_frequency = var.guardduty_finding_publishing_frequency
}

# guardduty config
resource "aws_guardduty_organization_configuration" "itgix_primary" {
  count                            = var.guardduty_organization_management_account ? 1 : 0
  auto_enable_organization_members = "NEW"

  detector_id = aws_guardduty_detector.itgix_primary[0].id

  datasources {
    s3_logs {
      auto_enable = var.enable_guardduty_s3_logs_scanning
    }

    kubernetes {
      audit_logs {
        enable = var.enable_guardduty_kubenetes_logs_scanning
      }
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.enable_guardduty_ec2_malware_protection
        }
      }
    }
  }
}

# delegated guardduty admin account
resource "aws_guardduty_organization_admin_account" "delegated_guardduty_admin_acc" {
  count = var.guardduty_organization_management_account ? 1 : 0

  admin_account_id = var.organization_security_account_id
}

# Requries S3 bucket and KMS key to already be craeted in Logging & Audit account
resource "aws_guardduty_publishing_destination" "itgix_audit_account" {
  count           = var.guardduty_organization_management_account ? 1 : 0
  detector_id     = aws_guardduty_detector.itgix_primary[0].id
  destination_arn = var.guardduty_findings_central_s3_bucket_arn
  kms_key_arn     = var.guardduty_findings_central_s3_bucket_kms_key_arn
}

# member accounts where guardduty is enabled - takes its config from delegated admin account
resource "aws_guardduty_member" "members" {
  count                      = var.guardduty_organization_management_account ? length(var.organization_member_account_ids) : 0
  account_id                 = var.organization_member_account_ids[count.index]
  detector_id                = aws_guardduty_detector.itgix_primary[0].id
  disable_email_notification = true
  email                      = var.guardduty_notification_mail # this is optional
  invite                     = var.invite_member_account       # this is optional
  invitation_message         = "guardduty invitation from itgix landing zones admin"

  lifecycle {
    ignore_changes = [
      email,
      invite
    ]
  }
}
