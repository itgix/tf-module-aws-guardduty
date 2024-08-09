# kms policy for guardduty s3 bucket where findings are stored
data "aws_iam_policy_document" "guardduty_kms" {
  count = var.guardduty_organization_audit_account ? 1 : 0

  statement {
    sid = "Allow use of the key for guardduty"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey"
    ]

    resources = [
      "arn:aws:kms:${var.aws_region}:${var.organization_audit_account_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow attachment of persistent resources for guardduty"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]

    resources = [
      "arn:aws:kms:${var.aws_region}:${var.organization_audit_account_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        "true"
      ]
    }
  }

  statement {
    sid = "Allow all KMS Permissions for Guardduty delegated admin account"
    actions = [
      "kms:*"
    ]

    resources = [
      "arn:aws:kms:${var.aws_region}:${var.organization_audit_account_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.organization_management_account_id}:root"]
    }
  }

  statement {
    sid = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Decrypt"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      # If we want to allow only a specific role
      #identifiers = ["arn:aws:iam::${var.organization_audit_account_id}:role/${var.assume_role_name}"]
      identifiers = [
        "arn:aws:iam::${var.organization_management_account_id}:root",
        "arn:aws:iam::${var.organization_audit_account_id}:root",
      ]
    }
  }
}

# kms key for encrypting guardduty s3 bucket contents
resource "aws_kms_key" "guardduty" {
  count                   = var.guardduty_organization_audit_account ? 1 : 0
  description             = "GuardDuty findings S3 bucet encryption CMK"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.guardduty_kms[0].json
  tags                    = var.guardduty_tags
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = var.guardduty_organization_audit_account ? 1 : 0
  name          = var.guardduty_s3_kms_key_alias
  target_key_id = aws_kms_key.guardduty[0].key_id
}
