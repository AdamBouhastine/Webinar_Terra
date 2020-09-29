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
     user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
	tags = {
		Name = "Terraform"	
	}
}



output "web-address" {
  value = "${aws_instance.web.public_dns}"
}


resource "null_resource" "example" {
     triggers = {
       "value" = "A example resource that does nothing!"
     }
}