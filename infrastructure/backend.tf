
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

terraform {
  # store the terraform state file in client PC
  backend "local" {
    path = "./dev_backend/terraform.tstate"
  }

  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################

  # store the terraform state file in s3
  #   backend "s3" { 
  #     module "state_backend_storage" {
  #       source                 = "./modules/backend"
  #       region                 = var.region
  #       s3_bucket_name         = var.s3_bucket_name
  #       aws_profile_name       = var.aws_profile_name
  #       document_directory     = var.document_directory
  #       dynamodb_table_name    = var.dynamodb_table_name
  #       enable_data_encryption = var.enable_data_encryption
  #       enable_data_version    = var.enable_data_version
  #     }
  #   }
}