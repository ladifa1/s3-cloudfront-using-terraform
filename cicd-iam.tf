# Create role for codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Create role for codebuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


# Set up the policy and specify the permission the iam role will be able to perform
resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "codepipeline_role_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
    "Version": "2012-10-17"
    "Statement": [
        {
            "Action": [
                "codestar-connections:UseConnection:*"
            ],
            "Resource": "{enter arn}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:*"
            ],
            "Resource": "{enter arn}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:*"
            ],
            "Resource": "{enter arn}",
            "Effect": "Allow"
        }
    ]
    
}
EOF
}


resource "aws_iam_role_policy" "codebuild_role_policy" {
  name = "codebuild_role_policy"
  role = aws_iam_role.codebuild_role.id

  policy = <<EOF
{
    "Version": "2012-10-17"
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Resource": "{enter arn}",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:*"
            ],
            "Resource": "{enter arn}",
            "Effect": "Allow"
        }
    ]
    
}
EOF


}







