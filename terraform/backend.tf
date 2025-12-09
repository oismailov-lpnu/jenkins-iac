terraform {
  backend "gcs" {
    bucket      = "lab12-tfstate"
    prefix      = "terraform/state"
  }
}
