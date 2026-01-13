locals {
  guardduty_runtime_additional_configurations = sort([
    for name, enabled in {
      EKS_ADDON_MANAGEMENT         = var.enable_guardduty_eks_addon_management
      EC2_AGENT_MANAGEMENT         = var.enable_guardduty_ec2_agent_management
      ECS_FARGATE_AGENT_MANAGEMENT = var.enable_guardduty_ecs_fargate_agent_management
    } : name if enabled
  ])
}

# guardduty runtime monitoring
resource "aws_guardduty_organization_configuration_feature" "runtime_monitoring" {
  count       = var.guardduty_organization_security_account && var.enable_guardduty_runtime_monitoring ? 1 : 0
  detector_id = var.guardduty_detector_id
  name        = "RUNTIME_MONITORING"
  auto_enable = "ALL"

  # Configure platform-specific runtime monitoring agents.
  # GuardDuty allows ONLY the top-level "RUNTIME_MONITORING" feature, while
  # platform support (EKS, EC2, ECS Fargate) is enabled via additional_configuration.
  #
  # This dynamic block conditionally enables:
  # - EKS_ADDON_MANAGEMENT         → EKS runtime monitoring via the GuardDuty add-on
  # - EC2_AGENT_MANAGEMENT         → EC2 instance runtime monitoring
  # - ECS_FARGATE_AGENT_MANAGEMENT → ECS Fargate runtime monitoring
  #
  # IMPORTANT:
  # - EKS_RUNTIME_MONITORING must NOT be enabled as a separate feature
  # - Enabling multiple additional configurations here is valid and supported
  dynamic "additional_configuration" {
    for_each = local.guardduty_runtime_additional_configurations

    content {
      name        = additional_configuration.value
      auto_enable = "ALL"
    }
  }

  lifecycle {
    ignore_changes = [additional_configuration]
  }
}

# guardduty additional features
resource "aws_guardduty_organization_configuration_feature" "s3_data_events" {
  count       = var.guardduty_organization_security_account || var.enable_s3_data_events_scanning ? 1 : 0
  detector_id = var.guardduty_detector_id // from mgmt account
  name        = "S3_DATA_EVENTS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "eks_audit_logs" {
  count       = var.guardduty_organization_security_account || var.enable_eks_audit_logs_scanning ? 1 : 0
  detector_id = var.guardduty_detector_id // from mgmt account
  name        = "EKS_AUDIT_LOGS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "ebs_malware_protection" {
  count       = var.guardduty_organization_security_account || var.enable_ebs_malware_protection_scanning ? 1 : 0
  detector_id = var.guardduty_detector_id // from mgmt account
  name        = "EBS_MALWARE_PROTECTION"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "rds_login_events" {
  count       = var.guardduty_organization_security_account || var.enable_rds_login_events_scanning ? 1 : 0
  detector_id = var.guardduty_detector_id // from mgmt account
  name        = "RDS_LOGIN_EVENTS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "lambda_network_logs" {
  count       = var.guardduty_organization_security_account || var.enable_lambda_network_logs_scanning ? 1 : 0
  detector_id = var.guardduty_detector_id // from mgmt account
  name        = "LAMBDA_NETWORK_LOGS"
  auto_enable = "ALL"
}
