provider "aws" {
  region = "us-east-1"
}

##############################
# S3 Bucket
##############################
resource "aws_s3_bucket" "cv_artifacts" {
  bucket = "${var.name}-cv-artifacts"
}

resource "aws_s3_bucket_public_access_block" "cv_artifacts_block" {
  bucket                   = aws_s3_bucket.cv_artifacts.id
  block_public_acls        = false
  block_public_policy      = false
  ignore_public_acls       = false
  restrict_public_buckets  = false
}

##############################
# Bucket Policy: public-read
##############################
resource "aws_s3_bucket_policy" "cv_artifacts_policy" {
  bucket = aws_s3_bucket.cv_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadForResume"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.cv_artifacts.arn}/*"
      }
    ]
  })

  # Ensure the public access block is applied first
  depends_on = [aws_s3_bucket_public_access_block.cv_artifacts_block]
}

##############################
# IAM User for GitHub Actions
##############################
resource "aws_iam_user" "github_actions" {
  name = "github-actions"
}

##############################
# IAM Policy for S3 access
##############################
resource "aws_iam_policy" "github_actions_s3_policy" {
  name        = "GithubActionsS3Access"
  description = "Allow GitHub Actions to upload files to S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.cv_artifacts.arn}/*"
      }
    ]
  })
}

##############################
# Attach Policy to User
##############################
resource "aws_iam_user_policy_attachment" "github_actions_attach" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_actions_s3_policy.arn
}

##############################
# IAM Access Keys (to use as GitHub Secrets)
##############################
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}

output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions_key.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}

output "cv_bucket_name" {
  description = "The name of the S3 bucket for CV artifacts"
  value       = aws_s3_bucket.cv_artifacts.bucket
}
