# bucket policy for guardduty that stores findings 
data "aws_iam_policy_document" "guardduty_s3_bucket" {
  count = var.guardduty_organization_audit_account ? 1 : 0
  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.guardduty_findings[0].arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "AWSBucketPermissionsCheck"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.guardduty_findings[0].arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid    = "Deny unencrypted object uploads. This is optional"
    effect = "Deny"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.guardduty_findings[0].arn}/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "aws:kms"
      ]
    }
  }

  statement {
    sid    = "Deny incorrect encryption header. This is optional"
    effect = "Deny"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.guardduty_findings[0].arn}/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"

      values = [
        aws_kms_key.guardduty[0].arn
      ]
    }
  }

  statement {
    sid    = "Deny non-HTTPS access"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.guardduty_findings[0].arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }

  statement {
    sid    = "Access logs ACL check"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      aws_s3_bucket.guardduty_findings[0].arn
    ]
  }

  statement {
    sid    = "Access logs write"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.guardduty_findings[0].arn,
      "${aws_s3_bucket.guardduty_findings[0].arn}/AWSLogs/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

# s3 bucket vesrioning
resource "aws_s3_bucket_versioning" "guardduty_findings" {
  count  = var.guardduty_organization_audit_account ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id
  versioning_configuration {
    status = var.s3_bucket_versioning_enabled
  }
}

# s3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_findings" {
  count  = var.guardduty_organization_audit_account ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.guardduty[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# s3 bucket lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "guardduty_findings" {
  count  = var.guardduty_organization_audit_account ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id

  rule {
    id     = "transition-objects-to-glacier"
    status = var.s3_bucket_enable_object_transition_to_glacier
    transition {
      days          = var.s3_bucket_object_transition_to_glacier_after_days
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "delete-objects"
    status = var.s3_bucket_enable_object_deletion
    expiration {
      days = var.s3_bucket_object_deletion_after_days
    }
  }
}

# s3 bucket for stroing guardduty findings in a central account
resource "aws_s3_bucket" "guardduty_findings" {
  count  = var.guardduty_organization_audit_account ? 1 : 0
  bucket = var.guardduty_s3_bucket_name

  force_destroy = true

  tags = var.guardduty_tags
}

# acl
#resource "aws_s3_bucket_acl" "guardduty_findings" {
#count  = var.guardduty_organization_audit_account ? 1 : 0
#bucket = aws_s3_bucket.guardduty_findings[0].id
#acl    = "private"
#}

resource "aws_s3_bucket_public_access_block" "guardduty_findings" {
  count                   = var.guardduty_organization_audit_account ? 1 : 0
  depends_on              = [aws_s3_bucket.guardduty_findings[0], aws_s3_bucket_policy.guardduty_findings]
  bucket                  = aws_s3_bucket.guardduty_findings[0].id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "guardduty_findings" {
  count      = var.guardduty_organization_audit_account ? 1 : 0
  depends_on = [aws_s3_bucket.guardduty_findings[0]]
  bucket     = aws_s3_bucket.guardduty_findings[0].id
  policy     = data.aws_iam_policy_document.guardduty_s3_bucket[0].json
}
