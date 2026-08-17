output "server_ip" {
  description = "Public IPv4 address of the application server"
  value       = digitalocean_droplet.app_server.ipv4_address
}

output "server_id" {
  description = "DigitalOcean Droplet ID"
  value       = digitalocean_droplet.app_server.id
}

output "firewall_id" {
  description = "Firewall ID"
  value       = digitalocean_firewall.app_firewall.id
}