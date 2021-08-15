##Define required terraform and provider version
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
      #version = "3.51.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>1.9"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
