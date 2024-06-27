#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install git -y
git clone https://github.com/GOUSERABBANI44/Mario.git
sudo mv Mario/* /var/www/html/
