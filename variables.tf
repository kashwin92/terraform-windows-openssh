variable "profile" {
  description   = "AWS default profile"
  type          = string
  default       = ""
}

variable "region" {
  description = "AWS default region"
  type        = string
  default     = ""
}

variable "ami" {
  description = "AMI id for Windows Server 2016 ec2 instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Windows instance type"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Windows pem key name"
  type        = string
  default     = ""
}

variable "windows_sg" {
  description = "Windows Security group"
  type        = string
  default     = ""
}
