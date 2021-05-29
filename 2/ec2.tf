resource "aws_eip" "ocft-app-eip" {
  vpc = true
  tags = {
      Name = "ocft-app-eip"
      Project = "ocft"
  }
}

resource "aws_instance" "ocft-app" {
  instance_type = "t2.micro"
  ami           = "ami-04876f29fd3a5e8ba" #Ubuntu 20.04
  key_name      = "ocft-keypair"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.ocft-sg-pub.id]
  subnet_id              = aws_subnet.ocft-subnet-pub-a.id

  tags = {
    Name = "ocft-app"
    Project = "ocft"
  }

  user_data = file("files/bootstrap.sh")
}

resource "aws_eip_association" "ocft-app-eip-assoc" {
    instance_id = aws_instance.ocft-app.id
    allocation_id = aws_eip.ocft-app-eip.id
}
