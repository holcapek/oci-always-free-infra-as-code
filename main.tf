resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_id
  display_name   = "${var.prefix} VCN"
  cidr_blocks    = ["10.0.0.0/16"]
  dns_label      = "ocaexam"
}

resource "oci_core_default_route_table" "default_route_table" {
  compartment_id             = var.tenancy_id
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block                 = "10.0.0.0/28"
  display_name               = "${var.prefix} subnet"
  compartment_id             = var.tenancy_id
  vcn_id                     = oci_core_vcn.vcn.id
  dns_label                  = "public"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.tenancy_id
  display_name   = "${var.prefix} internet gateway"
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = true
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_id
}

data "oci_core_images" "amd64_images" {
  compartment_id = var.tenancy_id
  display_name   = "Oracle-Linux-9.0-2022.08.17-0"
}

data "oci_core_images" "arm64_images" {
  compartment_id = var.tenancy_id
  display_name   = "Oracle-Linux-9.0-aarch64-2022.08.17-0"
}

resource "oci_core_instance" "amd64_instance_1" {
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id       = var.tenancy_id
  shape                = "VM.Standard.E2.1.Micro"
  preserve_boot_volume = false
  display_name         = "${var.prefix} adm64-1 instance"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.public_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file("id_rsa_oci-ocaexam-opc.pub")
    user_data           = filebase64("cloud-config.yaml")
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    firmware     = "UEFI_64"
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_id   = data.oci_core_images.amd64_images.images[0].id
    source_type = "image"
  }
}

resource "oci_core_instance" "amd64_instance_2" {
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id       = var.tenancy_id
  shape                = "VM.Standard.E2.1.Micro"
  preserve_boot_volume = false
  display_name         = "${var.prefix} adm64-2 instance"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.public_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file("id_rsa_oci-ocaexam-opc.pub")
    user_data           = filebase64("cloud-config.yaml")
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    firmware     = "UEFI_64"
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_id   = data.oci_core_images.amd64_images.images[0].id
    source_type = "image"
  }
}

resource "oci_core_instance" "arm64_instance_1" {
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id       = var.tenancy_id
  shape                = "VM.Standard.A1.Flex"
  preserve_boot_volume = false
  display_name         = "${var.prefix} arm64-1 instance"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.public_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file("id_rsa_oci-ocaexam-opc.pub")
    user_data           = filebase64("cloud-config.yaml")
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    firmware     = "UEFI_64"
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_id   = data.oci_core_images.arm64_images.images[0].id
    source_type = "image"
  }

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }
}

resource "oci_core_instance" "arm64_instance_2" {
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id       = var.tenancy_id
  shape                = "VM.Standard.A1.Flex"
  preserve_boot_volume = false
  display_name         = "${var.prefix} arm64-2 instance"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.public_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file("id_rsa_oci-ocaexam-opc.pub")
    user_data           = filebase64("cloud-config.yaml")
  }

  extended_metadata = {
    some_string   = "stringA"
    nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  launch_options {
    firmware     = "UEFI_64"
    network_type = "PARAVIRTUALIZED"
  }

  source_details {
    source_id   = data.oci_core_images.arm64_images.images[0].id
    source_type = "image"
  }

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }
}
