terraform {
  backend "remote" {
    organization = "axdane"

    workspaces {
      name = "ADN_Webi"
    }
  }
}

     resource "null_resource" "example" {
       triggers = {
         value = "A example resource that does nothing!"
       }
   }