terraform {
  backend "gcs" {
    bucket      = "jenkins-iac-vault-tfstate"
    prefix      = "terraform/state"
  }
}
