terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# S3 버킷 생성 
resource "aws_s3_bucket" "s3_bucket_prod" {
  bucket = "julook-prod-source-code"

  tags = {
    Name = "julook-prod-app"
    Environment = "Prod"
  }
}
