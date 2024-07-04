# EC2 Server
resource "aws_codedeploy_app" "prod_codedeploy_app" {
  compute_platform = "Server"
  name             = "julook_codedeploy_prod_app"
}


# CodeDeploy 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "prod_codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.prod_codedeploy_app.name
  deployment_group_name = "production"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "julook-ec2-instance"
    }
  }
}

