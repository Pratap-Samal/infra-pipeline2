resource "aws_instance" "apache_server" {
  ami           = "ami-051a31ab2f4d498f5" # Amazon Linux 2 (ap-south-1)
  instance_type = "t3.micro"

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.apache_sg.id]

  tags = {
    Name = "Apache-Server"
  }
}