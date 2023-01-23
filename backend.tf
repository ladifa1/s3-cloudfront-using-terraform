# terraform {
#   backend "s3" {
#     bucket  = "terraform-infra-staging"
#     key     = "terraform.tfstate"
#     region  = "eu-west-2"
#     encrypt = true
#   }
# }