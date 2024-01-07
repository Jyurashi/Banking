resource "aws_instance" "test_server" {
  ami = "ami-0a0f1259dd1c90938"
  instance_type = "t2.micro"
  key_name = "Jenkins"
  vpc_security_group_ids = ["sg-0eb647279d57a624f"]
  connection {
     type		= "ssh"
     user		= "ubuntu"
     private_key	= file("./Jenkins.pem")
     host 		= self.public_ip
}

provisioner "remote-exec" {
    inline = ["echo 'wait to start instance' "]
}
tags = {
  Name = "test-server"
}
provisioner "local-exec" {
    command = " echo ${aws_instance.test-server.public_ip} > inventory "
}
provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/target/BP/target/my-serverfiles/finance-playbook.yml"
}
}
