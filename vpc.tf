resource "aws_vpc" "demovpc" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "demovpc"
  }
}
