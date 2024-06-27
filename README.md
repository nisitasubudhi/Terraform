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



