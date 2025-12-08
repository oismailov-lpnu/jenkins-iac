terraform {
  backend "gcs" {
    bucket      = "lab12-tfstate"
    prefix      = "terraform/state"
    credentials = data.vault_kv_secret_v2.gcp_sa.data["sa-key-path"]
  }
}
