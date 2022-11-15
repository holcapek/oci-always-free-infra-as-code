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

resource "oci_core_public_ip" "public_ip" {
  compartment_id = var.tenancy_id
  lifetime       = "RESERVED"
  display_name   = "${var.prefix} public IP"
  lifecycle {
    ignore_changes = [
      private_ip_id
    ]
  }
}

resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.tenancy_id
  display_name   = "${var.prefix} load balancer"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.public_subnet.id]
  ip_mode        = "IPV4"
  is_private     = false

  reserved_ips {
    id = oci_core_public_ip.public_ip.id
  }

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}
