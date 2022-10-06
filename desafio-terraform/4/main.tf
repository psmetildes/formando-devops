provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "formando-devops-psmetildes"
    key    = "terraform-test.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
}