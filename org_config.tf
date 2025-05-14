# Enable Guardduty in delegated admin account - acc where Guardduty will be managed for the whole organization
# guardduty detector
resource "aws_guardduty_detector" "itgix_primary" {
  count  = var.guardduty_organization_management_account ? 1 : 0
  enable = true

  finding_publishing_frequency = var.guardduty_finding_publishing_frequency
}

# delegated guardduty admin account - we delegate this to the security account
resource "aws_guardduty_organization_admin_account" "delegated_guardduty_admin_acc" {
  count = var.guardduty_organization_management_account ? 1 : 0

  admin_account_id = var.organization_security_account_id
}

# member accounts where guardduty is enabled - takes its config from delegated admin account
resource "aws_guardduty_member" "members" {
  count      = var.guardduty_organization_security_account ? length(var.organization_member_account_ids) : 0
  account_id = var.organization_member_account_ids[count.index]

  # TODO: we need to pass this from the state of the mgmt account
  #detector_id = aws_guardduty_detector.itgix_primary[0].id
  detector_id = var.guardduty_detector_id

  disable_email_notification = var.disable_email_notification
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
