# This is an example of our AWS multi-region providers block
terraform {
   required_providers {
      	aws = {
       	source = "hashicorp/aws"
       	version = "~> 4.5"
		configuration_aliases = [aws.ohio, aws.ireland]
	}
	kubernetes = {
		source  = "hashicorp/kubernetes"
		version = "~> 2.1"
	}
	http = {
		source  = "terraform-aws-modules/http"
		version = "~> 2.4.1"
	}
	datadog = {
		source  = "DataDog/datadog"
		version = "~> 3.20"
	}
	random = {
		source  = "hashicorp/random"
		version = "~> 3.4"
	}
  }
}

# Here we set our multi-region roles
provider "aws" {
	alias  = "main"
	region = "us-east-1"
	assume_role {
	role_arn = var.role_arn_main
	}
}

}
	provider "aws" { // Alias to US-EAST-2 (Ohio)
	region = "us-east-2"
	alias  = "ohio"
	assume_role {
	role_arn = local.role_arn
	}
}
	provider "aws" { // Alias to US-EAST-2 (Ohio)
	region = "eu-west-1"
	alias  = "ireland"
	assume_role {
	role_arn = local.role_arn
	}
}

# And here we set AWS S3 bucket to store our TF state file
terraform {
	backend "s3" {
    bucket = "iac-tfstates-bucket"
    dynamodb_table = "iac-tfstates-locks"
    encrypt = true
    key = "terraform.tfstate"
    region = "us-east-1"
    workspace_key_prefix = "virathio/env"
    }
}
