terraform {
  backend "gcs" {
    bucket  = "lab12-tfstate"
    prefix  = "terraform/state"
    credentials = "/var/jenkins_home/data/lab12-sa-key.json"
  }
}
