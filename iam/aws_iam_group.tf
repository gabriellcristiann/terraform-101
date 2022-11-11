resource "aws_iam_group" "suport" {

  name = "suporte_group"

}

resource "aws_iam_user" "test-suport" {

  name = "test-suport"
  path = "/"

  tags = {
    env = "test"
  }

}


resource "aws_iam_policy" "policy_suport_ec2mfa" {

  name        = "ec2_suporte_policy"
  path        = "/"
  description = "Policy EC2 access and enable MFA to suport users"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeAvailabilityZones",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:StartInstances",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:CreateVirtualMFADevice",
          "iam:ListMFADevices",
          "iam:ListMFADeviceTags",
          "iam:ListVirtualMFADevices",
          "iam:ChangePassword",
          "iam:ListAccessKeys"
        ]
        Resource = "*"
      },
    ]
  })

}

resource "aws_iam_policy" "policy_suport_denyregions" {
  name        = "access_only_sa-east-1"
  path        = "/"
  description = "Policy deny access to all regions, except the region sa-east-1"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Deny"
        Action   = "ec2:*"
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = "sa-east-1"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  groups     = [aws_iam_group.suport.name]
  policy_arn = aws_iam_policy.policy_suport_denyregions.arn
}

resource "aws_iam_policy_attachment" "test-attach2" {
  name       = "test-attachment"
  groups     = [aws_iam_group.suport.name]
  policy_arn = aws_iam_policy.policy_suport_ec2mfa.arn
}

resource "aws_iam_user_group_membership" "test-suport" {
  user = aws_iam_user.test-suport.name

  groups = [
    aws_iam_group.suport.name
  ]
}

resource "aws_iam_user_login_profile" "suport-login" {
    user = aws_iam_user.test-suport.name
    password_reset_required = true
}

output "password" {
    value = aws_iam_user_login_profile.suport-login.password
}
