terraform {
  required_version = ">= 1.9.6, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.3.0, < 7.0.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}
