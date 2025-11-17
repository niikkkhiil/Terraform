provider "aws" {
    region = "ap-south-1"
}

resource "aws_iam_user" "user" {
    name = "terraform-user"
    path = "/system/"
    permissions_boundary = aws_iam_policy.user_policy.arn
  
}

resource "aws_iam_policy" "user_policy" {
    name = "terraform-user-policy"
    path = "/system/"
    description = "IAM policy for terraform user with S3 full access"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:*"
                ]
                Effect   = "Allow"
                Resource = "*"
            }
        ]
    })
  
}
