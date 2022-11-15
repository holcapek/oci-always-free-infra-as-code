output "amd64_instance_1_public_ip" {
  value = oci_core_instance.amd64_instance_1.public_ip
}
output "amd64_instance_2_public_ip" {
  value = oci_core_instance.amd64_instance_2.public_ip
}
output "arm64_instance_1_public_ip" {
  value = oci_core_instance.arm64_instance_1.public_ip
}
output "arm64_instance_2_public_ip" {
  value = oci_core_instance.arm64_instance_2.public_ip
}
