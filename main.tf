# 🔐 AWS Credentials Variables
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

provider "aws" {
  region     = "ap-southeast-1" # Singapore
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 🪄 AWS එකෙන්ම ලැටෙස්ට්ම Python Stack නම ඔටෝමැටිකලි හොයාගන්නවා
data "aws_elastic_beanstalk_solution_stack" "latest_python" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2023 .* running Python"
}

# 📦 1. Elastic Beanstalk Application එක (මෙතන නම වෙනස් කරා මචං)
resource "aws_elastic_beanstalk_application" "tftest" {
  name        = "banking-prod-app" # 👈 'banking-app' වෙනුවට මේ නම දැම්මා
  description = "Secure Banking App with Blue/Green Deployment"
}

# 🔵 2. Blue Environment එක
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "banking-app-blue"
  application         = aws_elastic_beanstalk_application.tftest.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.latest_python.name

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}

# 🟢 3. Green Environment එක
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "banking-app-green"
  application         = aws_elastic_beanstalk_application.tftest.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.latest_python.name

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}