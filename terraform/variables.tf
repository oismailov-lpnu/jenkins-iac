variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west4"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west1-a"
}

variable "instance_count" {
  description = "How many cheap instances to create"
  type        = number
  default     = 1
}

variable "ssh_username" {
  description = "Linux username that will own the SSH key"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key (single line: ssh-ed25519/ssh-rsa ...)"
  type        = string
}

variable "ssh_source_cidr" {
  description = "CIDR allowed to SSH (for lab you can use 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}
