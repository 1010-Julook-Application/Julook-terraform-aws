# IAM 역할 생성
resource "aws_iam_role" "ec2_codedeploy_role" {
  name = "EC2CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# IAM 정책 생성 (S3 및 CodeDeploy 접근 권한)
resource "aws_iam_policy" "codedeploy_s3_policy" {
  name        = "CodeDeployS3AccessPolicy"
  description = "Policy to allow CodeDeploy and S3 access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codedeploy:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}


# 정책을 역할에 연결하기 
resource "aws_iam_role_policy_attachment" "ec2_codedeploy_role_attachment" {
    role = aws_iam_role.ec2_codedeploy_role.name
    policy_arn = aws_iam_policy.codedeploy_s3_policy.arn
}


############# Codedeploy 애플리케이션 관련 역할 생성 #############



# Codedeploy 접근 iam 역할 생성
resource "aws_iam_role" "codedeploy_service_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Principal = {
                Service = "codedeploy.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }
    ]
  })
}


# CodeDeploy용 정책 연결
resource "aws_iam_role_policy_attachment" "codedeploy_service_role_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}



###################### 배포 권한 부여 ##########################
# 배포 권한 그룹 선택
resource "aws_iam_group" "manager" {
    name = "manager"
}

# Admin 그룹에 CodeDeploy 권한 부여
resource "aws_iam_group_policy_attachment" "admin_codedeploy_policy" {
  group      = aws_iam_group.manager.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

# Admin 그룹에 S3 권한 부여
resource "aws_iam_group_policy_attachment" "admin_s3_policy" {
  group      = aws_iam_group.manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


# 새로운 사용자 생성
resource "aws_iam_user" "manager_yerimee" {
  name = "yerimee"
}

# Add user to the manager group
resource "aws_iam_group_membership" "manager_group_membership" {
  name = "manager_group"
  users = [aws_iam_user.manager_yerimee.name]
  group = aws_iam_group.manager.name
}