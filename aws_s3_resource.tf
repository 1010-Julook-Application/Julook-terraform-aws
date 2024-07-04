# terraform 0.13 이후 버전
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# 프로바이더 지정
# provider "aws" {
#   region = "us-west-1"
  
# }

# 단일 프로바이더 다중 정의 시 alias 사용 가능 
provider "aws" {
  alias = "seoul"
  region = "ap-northeast-2"
}

# S3 버킷 생성 
resource "aws_s3_bucket" "log-terraform-bucket" {
  bucket = "log"

  tags = {
    Name = "log-test-bucket"
    Environment = "Dev"
  }
}

