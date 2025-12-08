terraform {
  backend "gcs" {
    bucket  = "lab12-tfstate"
    prefix  = "terraform/state"
    credentials = file("/var/jenkins_home/data/lab12-sa-key.json")
  }
}
