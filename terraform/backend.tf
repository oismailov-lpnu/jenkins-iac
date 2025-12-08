terraform {
  backend "gcs" {
    bucket      = "lab12-tfstate"
    prefix      = "terraform/state"
    credentials = var.gcp_credentials_json
  }
}
