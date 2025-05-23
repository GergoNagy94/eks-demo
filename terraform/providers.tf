provider "aws" {
  region = local.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.49"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

