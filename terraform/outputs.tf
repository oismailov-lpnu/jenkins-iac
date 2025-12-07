output "vm_public_ips_by_name" {
  description = "Map of instance name -> external IP"
  value = {
    for inst in google_compute_instance.cheap_vm :
    inst.name => inst.network_interface[0].access_config[0].nat_ip
  }
}

# (Optional, if you still want them separately)
output "vm_names" {
  description = "Names of created instances"
  value       = google_compute_instance.cheap_vm[*].name
}

output "vm_external_ips" {
  description = "External IP addresses"
  value = [
    for nic in google_compute_instance.cheap_vm[*].network_interface[0].access_config[0] :
    nic.nat_ip
  ]
}
