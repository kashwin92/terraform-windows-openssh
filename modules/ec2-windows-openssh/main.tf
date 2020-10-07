data "template_file" "user_data" {
  template = file("${path.module}/../../templates/ssh_powershell.tpl")
}

resource "aws_instance" "terraform" {
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  get_password_data = true
  user_data         = data.template_file.user_data.rendered

  tags = {
    Name = "Windows-Managed-node"
  }

  security_groups = [
    var.windows_sg
  ]

  provisioner "file" {
    source     = "/root/.ssh/id_rsa.pub"
    destination = "C:\\Users\\Administrator\\.ssh\\authorized_keys"

    connection {
      type      = "winrm"
      user      = "Administrator"
      password  = rsadecrypt(self.password_data,file("/home/ubuntu/openssh.pem"))
      host      = self.private_ip
      port      = 5986
      https     = true
      insecure  = true
    }
  }
}
