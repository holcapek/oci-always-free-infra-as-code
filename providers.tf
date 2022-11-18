terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.99"
    }
  }
  backend "s3" {
    bucket                      = "ocaexam-tf-state"
    key                         = "oci-always-free-infra-as-code/terraform.tfstate"
    region                      = "eu-frankfurt-1"
    endpoint                    = "https://fr3a9jifq6xo.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    shared_credentials_file     = "./ocaexam-tf-state-bucket-credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

provider "oci" {
  auth                = "SecurityToken"
  region              = "eu-frankfurt-1"
  config_file_profile = "DEFAULT"
}

