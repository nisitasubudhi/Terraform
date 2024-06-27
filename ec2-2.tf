resource "aws_instance" "demoinstance1" {
  ami                         = "ami-08a0d1e16fc3f61ea"
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "linux"
  vpc_security_group_ids      = [aws_security_group.demosg.id]
  subnet_id                   = aws_subnet.application-subnet-2.id
  associate_public_ip_address = true
  user_data                   = "${file("data1.sh")}"

  tags = {
    Name = "demo_instance2"
  }
}
