terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.99"
    }
  }
}

provider "oci" {
  auth                = "SecurityToken"
  region              = "eu-frankfurt-1"
  config_file_profile = "DEFAULT"
}

