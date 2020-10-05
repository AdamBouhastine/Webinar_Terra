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
  ami                    = "ami-0a669382ea0feb73a"
  instance_type          = "t2.micro"
  security_groups = [aws_security_group.http_access.name]  

    user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<h1> Webinar ADN </h1> <p> Deploy via GitHub</p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
	tags = {
		Name = "Terraform"	
	}
}

resource "aws_security_group" "http_access" {
  name = "Webinar_sg"
  ingress{
    from_port         = 80
    protocol          = "tcp"
    to_port           = 80
    cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "my-db-github" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  identifier           = "my-db"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot = true 

}


output "web-address" {
  value = "${aws_instance.web.public_dns}"
}


resource "null_resource" "example" {
     triggers = {
       "value" = "A example resource that does nothing!"
     }
}