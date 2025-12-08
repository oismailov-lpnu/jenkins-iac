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
  credentials  = data.vault_kv_secret_v2.gcp_sa.data["sa-key-path"]
}
