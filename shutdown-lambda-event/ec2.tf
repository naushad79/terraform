data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_owner]
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "testing-lambda-event"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "testing-lambda-event"
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.image.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    "Name" = "testing-lambda-event"
  }
}