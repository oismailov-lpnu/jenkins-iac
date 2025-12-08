provider "vault" {
  address = "http://localhost:8212"
  token   = "root"
}

data "vault_kv_secret_v2" "gcp_sa" {
  mount = "secret"
  name  = "gcp"
}