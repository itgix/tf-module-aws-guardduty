# guardduty runtime monitoring
# TODO: Only one of two features EKS_RUNTIME_MONITORING or RUNTIME_MONITORING can be added, adding both features will cause an error
resource "aws_guardduty_organization_configuration_feature" "runtime_monitoring" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "RUNTIME_MONITORING"
  auto_enable = "all"

  additional_configuration {
    name        = "EKS_ADDON_MANAGEMENT" # supports EKS_ADDON_MANAGEMENT | ECS_FARGATE_AGENT_MANAGEMENT | EC2_AGENT_MANAGEMENT
    auto_enable = "NEW"
  }
}

# TODO: is this needed if we can pass EKS_ADDON_MANAGEMENT to runtime_monitoring (above)
# resource "aws_guardduty_organization_configuration_feature" "eks_runtime_monitoring" {
#   detector_id = aws_guardduty_detector.itgix_primary.id
#   name        = "EKS_RUNTIME_MONITORING"
#   auto_enable = "ALL"
#
#   additional_configuration {
#     name        = "EKS_ADDON_MANAGEMENT"
#     auto_enable = "NEW"
#   }
# }

# guardduty additional features
# TODO: add conditionals to enable/disable each feature
resource "aws_guardduty_organization_configuration_feature" "s3_data_events" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "S3_DATA_EVENTS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "eks_audit_logs" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "EKS_AUDIT_LOGS"
  auto_enable = "all"
}

resource "aws_guardduty_organization_configuration_feature" "ebs_malware_protection" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "ebs_malware_protection"
  auto_enable = "all"
}

resource "aws_guardduty_organization_configuration_feature" "rds_login_events" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "RDS_LOGIN_EVENTS"
  auto_enable = "all"
}

resource "aws_guardduty_organization_configuration_feature" "lambda_network_logs" {
  count       = var.guardduty_organization_security_account ? 1 : 0
  detector_id = aws_guardduty_detector.itgix_primary[0].id
  name        = "LAMBDA_NETWORK_LOGS"
  auto_enable = "all"
}

# TODO: replace this with new guardduty config resource
# TODO: AWS has changed the guardduty APIs and those datasources are now deprecated; these are now handled with a separate resource
# resource "aws_guardduty_organization_configuration" "itgix_primary" {
#   count                            = var.guardduty_organization_security_account ? 1 : 0
#   auto_enable_organization_members = "NEW"
#
#   # TODO: we need to pass this from the state of the mgmt account
#   #detector_id = aws_guardduty_detector.itgix_primary[0].id
#   detector_id = var.guardduty_detector_id
#
#   datasources {
#     s3_logs {
#       auto_enable = var.enable_guardduty_s3_logs_scanning
#     }
#
#     kubernetes {
#       audit_logs {
#         enable = var.enable_guardduty_kubenetes_logs_scanning
#       }
#     }
#
#     malware_protection {
#       scan_ec2_instance_with_findings {
#         ebs_volumes {
#           auto_enable = var.enable_guardduty_ec2_malware_protection
#         }
#       }
#     }
#   }
# }
