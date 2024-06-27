terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_amplify_app" "first_demo" {
  name       = "nextjs_amplify_demo_1"
  repository = "https://github.com/faithoyebode/nextjs-amplify-demo-1"
  access_token = var.github_access_token
  enable_auto_branch_creation = true
  enable_branch_auto_build = true 
  platform = "WEB_COMPUTE"
  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  build_spec = <<-EOT
    version: 1
    frontend:
        phases:
            preBuild:
                commands:
                    - npm install
            build:
                commands:
                - npm run build
        artifacts:
            baseDirectory: .next
            files:
                - '**/*'
        cache:
            paths:
                - node_modules/**/*
  EOT
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.first_demo.id
  branch_name = "main"

  stage     = "PRODUCTION"

}

