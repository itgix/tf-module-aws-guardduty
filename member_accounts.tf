# member accounts where guardduty is enabled - takes its config from delegated admin account
resource "aws_guardduty_member" "members" {
  count      = var.guardduty_organization_security_account ? length(var.organization_member_account_ids) : 0
  account_id = var.organization_member_account_ids[count.index]

  detector_id = var.guardduty_detector_id // from mgmt account

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
