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
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = file("/var/jenkins_home/data/lab12-sa-key.json")
}

data "google_compute_image" "ubuntu_2204" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# SSH firewall rule (port 22)
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

# HTTP firewall rule (port 80)
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}


resource "google_compute_instance" "web" {
  count        = var.instance_count
  name         = "web-${count.index + 1}"
  machine_type = "f1-micro"

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
    # Enables external IP
  }

  # Inject SSH public key
  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
  }

  # Tags for firewall rules
  tags = ["lab", "ssh", "http"]

  depends_on = [
    google_compute_firewall.allow_ssh,
    google_compute_firewall.allow_http
  ]
}

output "instance_ips" {
  value = {
    for vm in google_compute_instance.web :
    vm.name => vm.network_interface[0].access_config[0].nat_ip
  }
}

output "instance_names" {
  value = google_compute_instance.web[*].name
}
