provider "aws" {
  profile = var.profile
  region  = var.region
}


module "aws-ec2-win2016" {
  source         = "./modules/ec2-windows-openssh"
  ami            = var.ami
  instance_type  = var.instance_type
  key_name       = var.key_name
  windows_sg     = var.windows_sg
}
