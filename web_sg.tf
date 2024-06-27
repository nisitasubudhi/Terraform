resource "aws_security_group" "demosg" {
  name        = "Demo sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demovpc.id
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
cidr_blocks      = ["0.0.0.0/0"]
}
  tags = {
    Name = "Demo sg"
  }
}
