resource "oci_kms_vault" "vault" {
  compartment_id = var.tenancy_id
  display_name   = "${var.prefix} vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "asymmetric_hsm_key" {
  compartment_id      = var.tenancy_id
  display_name        = "${var.prefix} assymetric HSM key"
  management_endpoint = oci_kms_vault.vault.management_endpoint
  protection_mode     = "HSM"

  key_shape {
    algorithm = "RSA"
    length    = 512
  }
}

resource "oci_identity_dynamic_group" "ca_dynamic_group" {
  compartment_id = var.tenancy_id
  description    = "${var.prefix} CA dynamic group"
  matching_rule  = "All { resource.type = 'certificateauthority' }"
  name           = "${var.prefix}-ca-dg"
}

resource "oci_identity_policy" "ca_dynamic_group_policy" {
  compartment_id = var.tenancy_id
  description    = "${var.prefix} CA dynamic group policy"
  name           = "${var.prefix}-ca-dg-policy"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.ca_dynamic_group.name} to use keys in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.ca_dynamic_group.name} to manage objects in tenancy",
  ]
}

resource "oci_certificates_management_certificate_authority" "ca" {
  compartment_id = var.tenancy_id
  description    = "${var.prefix} CA"
  kms_key_id     = oci_kms_key.asymmetric_hsm_key.id
  name           = "${var.prefix}-ca"
  certificate_authority_config {
    config_type = "ROOT_CA_GENERATED_INTERNALLY"
    subject {
      common_name = "${var.prefix} CA"
    }
  }
}

