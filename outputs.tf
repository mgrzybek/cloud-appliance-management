output "appliance_front_ip" {
  value       = openstack_networking_port_v2.appliance-management-front-port.all_fixed_ips
  description = "Front office IPv4 address"
}

output "appliance_back_ip" {
  value       = openstack_networking_port_v2.appliance-management-back-port.all_fixed_ips
  description = "Back office IPv4 address"
}

output "appliance_back_port" {
  value       = openstack_networking_port_v2.appliance-management-back-port
  description = "Back office port ID"
}

