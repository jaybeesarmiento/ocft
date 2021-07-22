resource "aws_eip" "test-app-eip" {
  vpc = true
  tags = {
    Name    = "test-app-eip"
    Project = "test"
  }
}

resource "aws_instance" "test-app" {
  instance_type = "t2.micro"
  ami           = "ami-04876f29fd3a5e8ba" #Ubuntu 20.04
  key_name      = "test-keypair"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.test-sg-pub.id]
  subnet_id              = aws_subnet.test-subnet-pub-a.id

  tags = {
    Name    = "test-app"
    Project = "test"
  }

  user_data = file("files/bootstrap.sh")
}

resource "aws_eip_association" "test-app-eip-assoc" {
  instance_id   = aws_instance.test-app.id
  allocation_id = aws_eip.test-app-eip.id
}
