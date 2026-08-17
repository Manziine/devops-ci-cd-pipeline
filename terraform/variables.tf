variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_id" {
  description = "DigitalOcean SSH key ID (run: doctl compute ssh-key list)"
  type        = string
}

variable "app_name" {
  description = "Application name (used for resource naming)"
  type        = string
  default     = "myapp"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "tor1"  # Toronto — closest to Ottawa
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-1vcpu-1gb"  # $6/month starter
}
