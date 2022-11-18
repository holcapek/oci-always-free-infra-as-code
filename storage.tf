data "oci_objectstorage_namespace" "bucket_namespace" {
  compartment_id = var.tenancy_id
}

resource "oci_objectstorage_bucket" "tf_bucket" {
  compartment_id = var.tenancy_id
  name           = "${var.prefix}-tf-state"
  namespace      = data.oci_objectstorage_namespace.bucket_namespace.namespace
  access_type    = "NoPublicAccess"
}
