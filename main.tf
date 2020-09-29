terraform {
  backend "remote" {
    organization = "axdane"

    workspaces {
      name = "ADN_Webi"
    }
  }
}

provider "aws" {
   profile    = "default"
   region     = "eu-west-2"
 }


resource "aws_instance" "web" {
  ami                    = "ami-05c424d59413a2876"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Rafik" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}


resource "null_resource" "example" {
     triggers = {
       "value" = "A example resource that does nothing!"
     }
}