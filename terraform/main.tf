terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("/var/jenkins_home/data/jenkins-iac-sa-key.json")
}

# Lookup Ubuntu image
data "google_compute_image" "ubuntu_2204" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# Firewall rule: allow SSH to instances with tag "ssh"
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-from-jenkins"
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [var.ssh_source_cidr]
  target_tags = ["ssh"]
}

# Cheap Ubuntu instances
resource "google_compute_instance" "web" {
  count        = var.instance_count
  name         = "web-${count.index}"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_2204.self_link
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  # Inject SSH public key into metadata
  metadata = {
    # format: "username:ssh-rsa AAAA... comment"
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
  }

  tags = ["lab", "ssh"]

  depends_on = [google_compute_firewall.allow_ssh]
}
