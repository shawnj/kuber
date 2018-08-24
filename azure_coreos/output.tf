output "public_ip_1" {
  value = "${module.azure_coreos1.public_ip_address}"
}

output "public_ip_2" {
  value = "${module.azure_coreos2.public_ip_address}"
}

output "public_dns_1" {
  value = "${module.azure_coreos1.public_ip_dns_name}"
}

output "public_dns_2" {
  value = "${module.azure_coreos2.public_ip_dns_name}"
}

output "public_dns_3" {
  value = "${module.azure_coreos3.public_ip_dns_name}"
}
