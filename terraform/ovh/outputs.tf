output "server_ip" {
  description = "Public IP of the server"
  value       = openstack_compute_instance_v2.server.access_ip_v4
}
