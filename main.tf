# AWSプロバイダー設定
provider "aws" {
  region = "ap-northeast-1"
}

# VPC作成
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "demo-vpc" }
}

# サブネット作成
resource "aws_subnet" "demo_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = { Name = "demo-subnet" }
}

# セキュリティグループ作成
resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "demo-sg" }
}

# EC2作成
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0036c153373f64296" # 東京リージョンのAmazon Linux2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  key_name      = "demo-keypair" # 先ほど作成したKey Pairの名前
  tags = { Name = "demo-ec2" }
}

