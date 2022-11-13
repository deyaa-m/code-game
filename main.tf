provider "aws" {
  region = "eu-west-1"
  profile = "deyaa"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    #owners = ["099720109477"] # Canonical
}

#variable "subnet_id" {
#    
#}
#
#data "aws_subnet" "subnet" {
#  id = var.subnet_id
#}


data "aws_subnet" "public" {
  filter {
    name   = "map_public_ip_on_launch"
    values = ["true"]
  }
}


resource "aws_instance" "test" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    key_name      = aws_key_pair.ssh-key.key_name
    subnet_id = data.aws_subnet.public.id
    user_data = <<EOF
        #!/bin/bash
        apt update
        apt install nginx
        EOF

    tags = {
        Name = "code-game"
    }
}

resource "aws_key_pair" "ssh_key" {
    key_name   = "code-game"
    public_key = file("~/.ssh/id_rsa.pub")
}

