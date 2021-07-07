resource "aws_instance" "My-Webserver" {

  ami                    = "ami-0ab4d1e9cf9a1215a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]
  iam_instance_profile   = aws_iam_instance_profile.test_profile.name
  tags = {
    Name = "My-Webserver"
  }
  key_name = "terrraform"
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo yum install docker",
      "sudo service docker start",
      "sudo chmod 666 /var/run/docker.sock",
      "sudo aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 031173150068.dkr.ecr.us-east-1.amazonaws.com",
      "docker pull 031173150068.dkr.ecr.us-east-1.amazonaws.com/spring:latest",
      "docker run -itd -p 8080:8080 031173150068.dkr.ecr.us-east-1.amazonaws.com/spring:latest"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/home/pratik/Downloads/terrraform.pem")
  }

}
