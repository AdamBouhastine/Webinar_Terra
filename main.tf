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

	user_data = << EOF
		#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" && sudo tee /var/www/html/index.html
	EOF
	tags = {
		Name = "Terraform"	
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