# Terraform
Three-tier architecture


Topic – Deploy three-tier architecture in AWS using Terraform 


Terraform:- 
Terraform is an infrastructure-as-code software tool created by HashiCorp. Users define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language, or optionally JSON.



Infrastructure as Code (IaC)- Terraform enables you to define your infrastructure resources and configurations in code using HashiCorp Configuration Language (HCL). This approach treats your infrastructure as code, making it versionable, repeatable, and more manageable.



Pre-requisites:-

•	Basic knowledge of AWS & Terraform

•	AWS Account

•	IAM user account/ Root account

•	GitHub account

•	AWS access & secret key



Setting up the environment

•	Launch an ec2 instance.

•	Connect it

•	Install terraform.



Setting Up AWS Infrastructure:

•	VPC and Subnets (Create an isolated network & Public and private subnets for different tiers.)

•	Internet Gateway and Route Table (Enable internet access & Manage routing rules for subnets.)

•	Application Load Balancer (Distribute incoming traffic across multiple EC2 instances.)

•	EC2 Instances with User Data (Run application code with Bootstrap script to set up instances on launch.)

•	RDS Instance (Managed relational database service)

•	Security Groups (Allow traffic to web servers & Allow traffic to RDS.)



STEP-1 (Create a file for the VPC)

•	We have to create a vpc.tf file & add the below code to it.
resource "aws_vpc" "demovpc" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "demovpc"
  }
}


STEP-2 (Create a file for the subnet)

•	Here, we will create total 6 subnets for the front-end tier & back-end tier with the mixture of public & private subnet.

•	Now, we have to create subnet.tf file & add the below code to it.
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
 cidr_block = "10.0.0.16/28"
  availability_zone       = "us-east-1b"
  tags = {
Name = "public-subnet-2"
  }
}
resource "aws_subnet" "application-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.32/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "application-subnet-1"
}
}
resource "aws_subnet" "application-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.48/28"
  availability_zone       = "us-east-1b"
  tags = {
      Name = "application-subnet-2"
  }
}
resource "aws_subnet" "database-subnet-1" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.64/28"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "database-subnet-1"
  }
}
resource "aws_subnet" "database-subnet-2" {
  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.80/28"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "database-subnet-2"
  }
}


STEP-3 (Create a file for the internet gateway)

•	Let’s create a igw.tf file & add the below code to it.

resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id

  tags = {
    Name = "demogateway"
  }
}


STEP-4 (Create a file for the Route Table)

•	We will create a route.tf file & add the below code to it.

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "Route to internet"
}
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.application-subnet-1.id
  route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.application-subnet-2.id
  route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "rt3" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "rt4" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route.id
}

•	In the above code, we are creating a new route table & forwarding all the requests to the 0.0.0.0/0 CIDR block.

•	We are attaching this route table to the subnet created earlier.
 So it will work as the Public subnet.


STEP-5 (Create a file for Ec2 instances)

•	Now, we will create a ec2.tf & ec2-2.tf files & add the below code to it.


(EC2.tf file)

resource "aws_instance" "demoinstance" {
  ami                         = "ami-08a0d1e16fc3f61ea"
  instance_type               = "t2.micro"
  count                            = 1
  key_name                    = "linuxx"
  vpc_security_group_ids      = ["${aws_security_group.demosg.id}"]
  subnet_id                   = "${aws_subnet.application-subnet-1.id}"
  associate_public_ip_address = true
  user_data                   = "${file("data.sh")}"

  tags = {
    Name = "demoinstance"
  }
}


(EC2-2.tf file)

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

We will use the user data to configure the ec2 instance.


STEP-6 (Create a file for security group for the frontEnd tier & backEnd tier too)

•	Now, we will create a sg.tf files & add the below code to it.

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
resource "aws_security_group" "database-sg" {
  name        = "Database SG"
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
    Name = "database-sg"
  }
}

•	Here, we opened 3306 ports for the inbound connection & we are opened all the ports for the outbound connection.



STEP-7 (Create a file for Application Load Balancer)

•	Now, we will create alb.tf file & add the below code to it.

# Creating External LoadBalancer
resource "aws_lb" "external-alb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demosg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

resource "aws_lb_target_group" "target-elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demovpc.id
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance[0].id
  port             = 80

depends_on = [aws_instance.demoinstance]

}
resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance1[0].id
  port             = 80
depends_on = [aws_instance.demoinstance1]
}

resource "aws_lb_listener" "external-alb" {
  load_balancer_arn = aws_lb.external-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb.arn
  }
}

•	As we can see that the above load balancer is of type external.

•	Load Balancer type is set to application.

•	The aws_lb_target_group_attachment resource will attach our instances to the Target group.

•	The load balancer will listen requests on port 80.



STEP-8 (Create a file for Listener)

•	Now, we will create listener.tf file & add the below code to it.

  listener_arn = aws_lb_listener.external-alb.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb.arn
  }
condition {
    path_pattern {
      values = ["/my_listener_rule/*"]
    }
  }
}



STEP-9 (Create a file for the RDS instance)

•	Let’s create a rds.tf file & add the below code to it.

#creating RDS Instance
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.database-subnet-1.id, aws_subnet.database-subnet-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.default.id
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  multi_az               = true
  username               = "admin"
  password               = "admin123"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
}


STEP-10 (Create a file for outputs)

•	Let’s create a output.tf file & add the below code to it.

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.external-alb.dns_name
}

•	From the above code we will get the DNS of the application load balancer.



STEP-11 (Create a file for user data)

•	Now, we will create two user data files for both the instances (data.sh & data1.sh) & add the below code to it.


(data.sh)

#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install git -y
git clone https://github.com/GOUSERABBANI44/Mario.git
sudo mv Mario/* /var/www/html/


(data1.sh)

#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install git -y
git clone https://github.com/GOUSERABBANI44/food.git
sudo mv food/* /var/www/html/



•	Now we can see through the load balancer DNS it’s now showing both the static websites by hitting the DNS couple of time.

![image](https://github.com/nisitasubudhi/Terraform/assets/162950721/3bb4a564-e83f-4eb1-84d8-fa8ccbbb7713)

![image](https://github.com/nisitasubudhi/Terraform/assets/162950721/4583501c-fe6d-4f9d-8967-55cbdc7b707a)

