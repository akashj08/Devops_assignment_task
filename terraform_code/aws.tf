provider "aws" {
    shared_credentials_file = "/home/ubuntu/.aws/creds"
    profile = "default"
    region = "${var.aws_region}"
}